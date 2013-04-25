--[[
 Copyright (C) 2013 <reyalp (at) gmail dot com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License version 2 as
  published by the Free Software Foundation.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--]]
--[[
simple script to connect and shoot multiple cameras
no effort is made to shoot cameras in sync, see multicam.lua for that

usage

chdkptp -e"exec m=dofile('simplemulticam.lua'); \
  m.connect({dev='<cam 1 dev id>'}); \
  m.connect({dev='<cam 2 dev id>'}); \
  m.shoot({tv96=<tv96>,iso=<real ISO value>})"

]]
local m = {}

-- connections
m.cams = {}

m.verbose=2

m.infomsg = util.make_msgf( function() return m.verbose end, 1)
m.dbgmsg = util.make_msgf( function() return m.verbose end, 2)
--[[
devpsec should be an array of
{
	dev={device},
	bus={bus}
}
but for compatibility with test_keypedal.sh, accepts empty bus and attempts to guess
--]]
function m.connect(devspec)
	if type(devspec) ~= 'table' then
		error('missing or invalid devspec:'..tostring(devspec))
	end
	if not devspec.dev then
		error('missing device id')
	end
	if not devspec.bus then
		local devs=chdk.list_usb_devices()
		if not devs then
			error('no devices found');
		end
		for i,d in ipairs(devs) do
			if devspec.dev == d.dev then
				if devspec.bus then
					error(string.format("multiple devices matching dev %s\n",tostring(devspec.dev)))
				end
				m.dbgmsg("found bus %s for dev %s\n",tostring(d.bus),tostring(devspec.dev))
				devspec.bus = d.bus
			end
		end
		if not devspec.bus then
			error('no devices match dev:'..tostring(devspec.dev))
		end
	end
	local lcon,msg = chdku.connection(devspec)
	-- if not already connected, try to connect
	if lcon:is_connected() then
		lcon:update_connection_info()
	else
		local status,err = lcon:connect()
		if not status then
			error(string.format('connect failed bus:%s dev:%s err:%s\n',devspec.dev,devspec.bus,tostring(err)))
		end
	end
	-- if connection didn't fail
	if lcon:is_connected() then
		m.dbgmsg('%d:%s bus=%s dev=%s sn=%s\n',
			#m.cams+1,
			lcon.ptpdev.model,
			lcon.usbdev.dev,
			lcon.usbdev.bus,
			tostring(lcon.ptpdev.serial_number))
		table.insert(m.cams,lcon)
	end
end
--[[
connect to all available devices
--]]
function m.connect_all()
	local devs=chdk.list_usb_devices()
	if not devs then
		error('no devices found');
	end
	for i,d in ipairs(devs) do
		m.connect(d)
	end
end

--[[
do con:exec on all connections
--]]
function m.exec(code,opts)
	for i,lcon in ipairs(m.cams) do
		status,err = lcon:exec(code,opts)
		if not status then
			error(string.format('exec cam %d failed %s',i,tostring(err)))
		end
	end
end
--[[
--shoot(opts)
where opts is (optionally)
{
tv96=<tv96>,
iso=<iso_real>,
}
does not wait for execution to complete or check for runtime errors
--]]
function m.shoot(opts)
	if opts then
		optstr = util.serialize(opts)
	else 
		optstr = '{}'
	end
	m.exec([[
function do_shot(opts)
	if opts.tv96 then
		set_tv96_direct(opts.tv96)
	end
	if opts.iso then
		set_iso_real(opts.iso)
	end
	shoot()
end
]]..'do_shot('..optstr..')')
end
return m
