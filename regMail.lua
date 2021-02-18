mailLib = {}
function mailLib.applyMail(mail)
	local ts = require("ts")
	local header_send = {
		["authority"] = "rootsh.com",
		["method"] = "POST",
		["path"] = "/applymail",
		["scheme"] = "https",
		["accept"] = "application/json, text/javascript, */*; q=0.01",
		["accept-encoding"] = "gzip, deflate, br",
		["accept-language"] = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7",
		["content-length"] = "27",
		["content-type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	}
	local body_send = {
		["mail"]  = mail,
	}
	ts.setHttpsTimeOut(60) 
	local code,status_resp, body_resp = ts.httpsPost("https://rootsh.com/applymail", header_send, body_send)
	if code == 200 then
		local json = ts.json
		local bodyTab = json.decode(body_resp)
		if bodyTab.success == "true" then
			nLog(mail.." 邮箱申请成功")
			return true
		else
			dialog("邮箱申请失败", 0)
			lua_exit()
		end
	end
end
function mailLib.getMail(mail)
	local ts = require("ts")
	local header_send = {
		["authority"] = "rootsh.com",
		["method"] = "POST",
		["path"] = "/getmail",
		["scheme"] = "https",
		["accept"] = "application/json, text/javascript, */*; q=0.01",
		["accept-encoding"] = "gzip, deflate, br",
		["accept-language"] = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7",
		["content-length"] = "27",
		["content-type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	}
	local body_send = {
		["mail"]  = mail,
	}
	ts.setHttpsTimeOut(60) 
	local code,status_resp, body_resp = ts.httpsPost("https://rootsh.com/getmail", header_send, body_send)
	if code == 200 then
		local json = ts.json
		if body_resp ~= "NO NEW MAIL" then
			local bodyTab = json.decode(body_resp)
			if #bodyTab.mail > 0 then
				nLog("共有 "..#bodyTab.mail .." 邮件")
				return bodyTab.mail[#bodyTab.mail][3],bodyTab.mail[#bodyTab.mail][5]		--返回邮件主题和邮件打开地址
			end
		else
			toast("可能还未申请邮箱",2)
			mSleep(2000)
		end
	end
end
function mailLib.checkMail(mailName,mailcode)
	local ts = require("ts")
	local header_send = {
		["Content-Type"] = "application/x-www-form-urlencoded",
		["Accept-Encoding"] = "gzip",
		["typeget"] = "ios"
	}
	local body_send = {["msg"] = "hello"}
	ts.setHttpsTimeOut(60) 
	local code,header_resp, body_resp = ts.httpsGet("https://rootsh.com/win/"..mailName.."(a)taptap-_-icu/"..mailcode, header_send,body_send)
	if code == 200 then
		nLog(body_resp)
		return body_resp		--返回邮件内容
	end
end

function mailLib.destroyMail(mail)
	local ts = require("ts")
	local header_send = {
		["authority"] = "rootsh.com",
		["method"] = "POST",
		["path"] = "/destroymail",
		["scheme"] = "https",
		["accept"] = "application/json, text/javascript, */*; q=0.01",
		["accept-encoding"] = "gzip, deflate, br",
		["accept-language"] = "zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7",
		["content-length"] = "27",
		["content-type"] = "application/x-www-form-urlencoded; charset=UTF-8",
	}
	local body_send = {
		["mail"]  = mail,
	}
	ts.setHttpsTimeOut(60) 
	local code,status_resp, body_resp = ts.httpsPost("https://rootsh.com/destroymail", header_send, body_send)
	if code == 200 then
		local json = ts.json
		local bodyTab = json.decode(body_resp)
		if bodyTab.success == "true" then
			toast("邮箱销毁成功",2)
			return true
		end
	end
end
