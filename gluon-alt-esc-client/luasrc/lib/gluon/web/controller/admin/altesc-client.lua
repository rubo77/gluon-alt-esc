--module("luci.controller.admin.altesc-client", package.seeall)
--
--function index()
--	entry({"admin", "altesc-client"}, cbi("admin/altesc-client"), _("Alt-ESC Client"), 10)
--end

entry({"admin", "altesc-client"}, model("admin/altesc-client"), _("Alt-ESC Client"), 10)
