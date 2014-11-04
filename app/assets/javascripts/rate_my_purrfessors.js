window.RateMyPurrfessors = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    RateMyPurrfessors.colleges = new RateMyPurrfessors.Collections.Colleges();
		RateMyPurrfessors.colleges.fetch({
			success: function () {
				RateMyPurrfessors.professors = new RateMyPurrfessors.Collections.Professors({});
				RateMyPurrfessors.professors.fetch({
					success: function() {
						new RateMyPurrfessors.Routers.Router();
						Backbone.history.start();
					}
				});
			}
		});
  }
};

$(document).ready(function(){
  RateMyPurrfessors.initialize();
});
