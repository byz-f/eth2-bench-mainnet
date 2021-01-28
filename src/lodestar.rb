#!/usr/bin/env ruby

# REQUIRES ARCHLINUX W/ SUDO, SYSSTAT, NETHOGS
require 'net/http'
require 'uri'
require 'json'
require 'thread'

# LODESTAR
@HOST = "127.0.0.1"
@HTTP = 9596
@METR = 8008
@DATA = "/srv/chain/lodestar/chain-db"
@TIME = -9
@DEV = "eno1"
@PROC = "node" # really

# GET BYTES INTEGER FROM KB FLOAT
def bytes_from_kb kb
	b = (kb * 1024.0).round
end

# GET HTTP API FROM ENDPOINT
def get_api endpoint
	uri = URI.parse("http://#{@HOST}:#{@HTTP}#{endpoint}")
	request = Net::HTTP::Get.new(uri)
	request["Accept"] = "application/json"
	options = { use_ssl: uri.scheme == "https" }
	response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
		http.request(request)
	end
end

# GET METRIC FROM METRICS
def get_metrics metric, pos
	uri = URI.parse("http://#{@HOST}:#{@METR}/metrics")
	response = Net::HTTP.get_response(uri)
	result = -9
	response.body.each_line do |m|
		if not m[0].include? "#" and m.include? metric
			result = m.split(" ")[1].to_f.to_i
		end
	end
	result
end

# UNIX TIME [s]
def get_unix_time
	u = Time.now.utc.to_i
	if @TIME < 0
		@TIME = u
	end
	u
end

# TIME SINCE START [s]
def get_time_running
	u = get_unix_time
	t = -9
	if @TIME > 0
		t = u - @TIME
	end
end

# SLOT NUMBER [1]
def get_slot_height
	begin
		response = get_api "/eth/v1/beacon/headers/head"
		h = JSON.parse(response.body)["data"]["header"]["message"]["slot"].to_i
	rescue
		h = -9
	end
end

# SLOTS PER SECOND [1/s]
def get_sync_speed
	begin
		v = get_metrics "sync_slots_per_second", 1
	rescue
		v = -9
	end
end

# DB SIZE [B]
def get_database_size
	begin
		s = `du -bs #{@DATA} 2> /dev/null`.to_i
	rescue
		s = -9
	end
end

# MEM USAGE [B]
def get_memory_usage
	begin
		m = get_metrics "process_resident_memory_bytes", 1
	rescue
		m = -9
	end
end

# PEER COUNT [1]
def get_peer_count
	begin
		m = get_metrics "libp2p_peers", 1
	rescue
		m = -9
	end
end

# NETWORK TRAFFIC [B/s]
def get_network_traffic
	r = `sudo nethogs -C -c2 -t #{@DEV}` # this takes < 2 seconds
	result = [0, 0] # nethogs only sees the process if traffic > 0
	r.each_line do |x|
		if x.include? @PROC
			y = bytes_from_kb x.split(" ")[1].to_f
			z = bytes_from_kb x.split(" ")[2].to_f
			result = [y, z]
		end
	end
	result
end

# CPU USAGE [%]
def get_cpu_usage
	a = `mpstat 1 1` # this takes < 1 second
	result = -9
	a.each_line do |l|
		if l.include? "Average"
			result = l.split(" ")[2]
		end
	end
	result
end

print "unix,time,slot,sps,db,mem,pc,out,inc,cpu\n"

loop do
	threads = []
	a, u, t, h, v, s, m, c = -9
	r = [-9, -9]
	threads << Thread.new {u = get_unix_time}
	threads << Thread.new {t = get_time_running}
	threads << Thread.new {r = get_network_traffic}
	threads << Thread.new {a = get_cpu_usage}
	threads << Thread.new {h = get_slot_height}
	threads << Thread.new {v = get_sync_speed}
	threads << Thread.new {s = get_database_size}
	threads << Thread.new {m = get_memory_usage}
	threads << Thread.new {c = get_peer_count}
	threads << Thread.new {sleep 1} # make sure this loop takes >= 1 second
	threads.each{ |t| t.join unless t == Thread.current }
	print "#{u},#{t},#{h},#{v},#{s},#{m},#{c},#{r[0]},#{r[1]},#{a}\n"
end
