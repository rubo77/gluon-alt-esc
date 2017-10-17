local uci = require("simple-uci").cursor()
local util = require 'gluon.util'
local site = require 'gluon.site_config'
local hash = require 'hash'

local function get_client(uci)
	local client
	uci:foreach('gluon-alt-esc-client', 'client',
		function(s)
			 client = s
			 return false
		end
	)
	return client
end

local client = get_client(uci)['.name']
local disabled = uci:get_first('gluon-alt-esc-client', 'client', "disabled")

local site_code

if site.site_code then
	sitecode = site.site_code
else
	sitecode = "ff"
end

-- reserve space for suffixes, SSID limited to 32 characters by standard
local ssidlen = 32 - string.len(" #abcd #" .. sitecode)
local ssiddata = uci:get('wireless', 'altesc_radio0', "ssid")

-- Remove sitecode suffix
if ssiddata and string.match(ssiddata, " #" .. sitecode .. "$") then
	ssiddata = string.match(ssiddata, "^(.*) #" .. sitecode .. "$")
end

-- Remove zone suffix
if ssiddata and string.match(ssiddata, " #%x%x%x%x$") then
	ssiddata = string.match(ssiddata, "^(.*) #%x%x%x%x$")
end

local f = Form(translate("Alternative Exit Service Collaborator - Client"))
local s = f:section(Section, nil, translate(
	'Here you can add a WiFi interface with an alternative gateway for its '
	.. 'Internet connectivity. Usually, you connect to a node, that has the '
	.. 'Alt-ESC-Provider package activated (although other systems can '
	.. 'provide access too).'
))

local enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.default = ssiddata and disabled and disabled == "0"

local ssid = s:option(Value, "ssid", translate("Name (SSID)"), translate('i.e. "Freifunk-Direkt"'))
ssid:depends(enabled, true)
ssid.datatype = "maxlength(" .. ssidlen .. ")"
ssid.default = ssiddata

local exit4data = uci:get_first('gluon-alt-esc-client', 'client', "exit4")
local exit4flag = s:option(Flag, "exit4flag", translate("redirect IPv4 to an Alt-ESC-Provider"))
exit4flag:depends(enabled, true)
exit4flag.default = (exit4data and exit4data ~= "")

local exit4 = s:option(Value, "exit4", "Exit ID for IPv4", translate("MAC of the node, that serves as Alt-ESC-Provider"))
exit4:depends(exit4flag, true)
--exit4.datatype = "macaddr"
exit4.default = exit4data

local exit6data = uci:get_first('gluon-alt-esc-client', 'client', "exit6")
local exit6flag = s:option(Flag, "exit6flag", translate("redirect IPv6 to an Alt-ESC-Provider"))
exit6flag:depends(enabled, true)
exit6flag.default = (exit6data and exit6data ~= "")

local exit6 = s:option(Value, "exit6", "Exit ID for IPv6", translate("MAC of the node, that serves as Alt-ESC-Provider"))
exit6:depends(exit6flag, true)
--exit6.datatype = "macaddr"
exit6.default = exit6data

local landata = uci:get_first('gluon-alt-esc-client', 'client', "altesc_on_lan")
local altesc_on_lan = s:option(Flag, "altesc_on_lan", translate("Enable redirection on LAN-Ports"))
altesc_on_lan:depends(enabled, true)
altesc_on_lan.default = landata and landata == '1'

function f:write(self, state, data)
	local client = get_client(uci)['.name']

	uci:set('gluon-alt-esc-client', client, 'disabled', enabled.data and '0' or '1')
	uci:set('gluon-alt-esc-client', client, 'exit4', exit4.data or '')
	uci:set('gluon-alt-esc-client', client, 'exit6', exit6.data or '')
	uci:set('gluon-alt-esc-client', client, 'altesc_on_lan', altesc_on_lan.data and '1' or '0')

	uci:commit('gluon-alt-esc-client')

	i=0
	util.iterate_radios(uci,
		function(radio, index)
			local name = "altesc_" .. radio

			if enabled.data then
				local macaddr = util.get_wlan_mac(uci, radio, index, 4)
				local exit4data = exit4.data or ""
				local exit6data = exit4.data or ""
				local sitecode
				local zone = string.sub(hash.md5(exit4data .. "," .. exit6data .. "," .. ssid.data), 0, 4)

				if site.site_code then
					sitecode = site.site_code
				else
					sitecode = "ff"
				end

				uci:section('wireless', "wifi-iface", name,
					{
						ifname = "altesc" .. i,
						device = radio,
						network = "client",
						mode = "ap",
						macaddr = macaddr,
						ssid = ssid.data .. " #" .. zone .. " #" .. sitecode,
						disabled = '0',
					}
				)
			else
				uci:set('wireless', name, "disabled", 1)
			end

			i=i+1
		end
	)
	uci:commit('wireless')
end

return f
