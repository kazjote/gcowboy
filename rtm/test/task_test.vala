using Xml;

void add_task_tests () {
    Test.add_func ("/rtm/task/due", () => {
        var task_body = """
            <task due=""></task>
        """;

        Xml.Doc* doc = Parser.parse_doc (task_body);
        Xml.Node* root = doc->get_root_element ();

        var task = new Rtm.Task (root);

        assert (task.due == null);

        task_body = """
            <task due="2006-05-07T10:19:54Z"></task>
        """;

        doc = Parser.parse_doc (task_body);
        root = doc->get_root_element ();

        task = new Rtm.Task (root);

        var datetime = task.due;

        assert (task.due.get_year () == 2006);
        assert (task.due.get_month () == 5);
        assert (task.due.get_day_of_month () == 7);
        assert (task.due.get_hour () == 10);
        assert (task.due.get_minute () == 19);
        assert (task.due.get_second () == 54);
    });
}

// vim: ts=4 sw=4
