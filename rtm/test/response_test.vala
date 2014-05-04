void add_response_tests () {

    Test.add_func ("/rtm/response/task_series/complex_hierarchy", () => {
        var body = """
          <rsp stat='ok'>
            <tasks>
              <list id="1" current="2006-05-07T08:13:26Z">
                <taskseries id="11" created="2006-05-07T10:19:54Z" modified="2006-05-07T10:19:54Z"
                           name="Get Bananas" source="api" url="http://bananas.com" location_id="">
                  <task id="111" due="" has_due_time="0" added="2006-05-07T10:19:54Z"
                       completed="true" deleted="" priority="N" postponed="0" estimate=""/>
                  <task id="112" due="" has_due_time="0" added="2006-05-07T10:19:54Z"
                       completed="" deleted="" priority="N" postponed="0" estimate=""/>
                </taskseries>
                <taskseries id="12" created="2006-05-07T10:19:54Z" modified="2006-05-07T10:19:54Z"
                           name="Get Candys" source="api" url="http://bananas.com" location_id="">
                  <task id="121" due="" has_due_time="0" added="2006-05-07T10:19:54Z"
                       completed="" deleted="" priority="N" postponed="0" estimate=""/>
                </taskseries>
              </list>
              <list id="2" current="2006-05-07T08:13:26Z">
                <taskseries id="21" created="2006-05-07T10:19:54Z" modified="2006-05-07T10:19:54Z"
                           name="Get Bikes" source="api" url="http://bananas.com" location_id="">
                </taskseries>
              </list>
            </tasks>
          </rsp>
          """;

        var response = new Rtm.Response (body);

        response.process ();

        assert (response.stat == Rtm.Stat.OK);
        assert (response.task_series.length () == 3);

        var task_serie = response.task_series.nth_data (0);
        assert (task_serie.list_id == 1);
        assert (task_serie.id == 11);
        assert (task_serie.tasks.length () == 2);

        var task = task_serie.tasks.nth_data (0);
        assert (task.id == 111);
        assert (task.completed == "true");

        task = task_serie.tasks.nth_data (1);
        assert (task.id == 112);
        assert (task.completed == "");

        task_serie = response.task_series.nth_data (1);
        assert (task_serie.list_id == 1);
        assert (task_serie.id == 12);
        assert (task_serie.tasks.length () == 1);

        task = task_serie.tasks.nth_data (0);
        assert (task.id == 121);

        task_serie = response.task_series.nth_data (2);
        assert (task_serie.list_id == 2);
        assert (task_serie.id == 21);
    });

    Test.add_func ("/rtm/response/task_series/task_fields", () => {
        var body = """
          <rsp stat='ok'>
            <tasks>
              <list id="1" current="2006-05-07T08:13:26Z">
                <taskseries id="11" created="2006-05-07T10:19:54Z" modified="2006-05-07T10:19:54Z"
                           name="Get Bananas" source="api" url="http://bananas.com" location_id="">
                  <task id="111" due="" has_due_time="0" added="2006-05-07T10:19:54Z"
                       completed="" deleted="" priority="N" postponed="0" estimate=""/>
                </taskseries>
              </list>
            </tasks>
          </rsp>
          """;

        var response = new Rtm.Response (body);

        response.process ();

        var task_serie = response.task_series.nth_data (0);

        assert (task_serie.name == "Get Bananas");
    });
}

// vim: ts=4 sw=4
