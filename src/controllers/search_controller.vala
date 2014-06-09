using Gtk;

namespace Controllers
{
    public class SearchController
    {
        private Entry entry { get; set; }
        private Models.TaskListsModel task_lists_model { get; set; }

        public SearchController (Entry _entry, Models.TaskRepository repository, RtmWrapper rtm, Models.TaskListsModel _task_lists_model, Views.TaskListsView task_lists_view)
        {
            entry = _entry;
            task_lists_model = _task_lists_model;

            entry.activate.connect (() => {
                entry.sensitive = false;

                var search_task_list_model = new Models.SearchTaskListModel (repository, rtm, entry.text);
                var tree_path = task_lists_model.add_task_list (search_task_list_model);

                search_task_list_model.finished_fetching.connect (() => {
                    entry.text = "";
                    entry.sensitive = true;
                });

                task_lists_view.activate_path (tree_path);
            });
        }
    }
}

// vim: ts=4 sw=4
