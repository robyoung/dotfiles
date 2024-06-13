local task_properties = "\n:PROPERTIES:\n:CREATED:  %u\n:END:"
require("orgmode").setup({
  org_agenda_files = { "~/Notes/*" },
  org_default_notes_file = "~/Notes/Inbox.org",
  org_todo_keywords = { "TODO(t)", "DOING(d)", "BLOCKED(b)", "|", "DONE(x)", "ABANDONED(a)" },
  org_agenda_templates = {
    t = { description = 'Task', template = '* TODO %?' .. task_properties },
    h = { description = 'Headline', template = '* %?' .. task_properties },
  },
  org_archive_location = 'Archive/%s',
})
