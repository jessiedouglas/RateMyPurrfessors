window.RateMyPurrfessors = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
		RateMyPurrfessors.departments = JSON.parse($("script#departments").html());
		RateMyPurrfessors.gradYears = JSON.parse($("script#grad_years").html());
		RateMyPurrfessors.grades = JSON.parse($("script#grades").html());
		
    RateMyPurrfessors.colleges = new RateMyPurrfessors.Collections.Colleges();
		RateMyPurrfessors.colleges.fetch({
			success: function () {
				RateMyPurrfessors.professors = new RateMyPurrfessors.Collections.Professors({});
				RateMyPurrfessors.professors.fetch({
					success: function() {
						RateMyPurrfessors.router = new RateMyPurrfessors.Routers.Router();
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
