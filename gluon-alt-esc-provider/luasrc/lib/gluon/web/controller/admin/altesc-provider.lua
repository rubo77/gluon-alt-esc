--module("luci.controller.admin.altesc-provider", package.seeall)
--
--function index()
--	entry({"admin", "altesc-provider"}, cbi("admin/altesc-provider"), _("Alt-ESC Provider"), 11)
--end

entry({"admin", "altesc-provider"}, model("admin/altesc-provider"), _("Alt-ESC Provider"), 11)
