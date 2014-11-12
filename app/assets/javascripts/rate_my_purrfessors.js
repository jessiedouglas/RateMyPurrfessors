window.RateMyPurrfessors = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
		RateMyPurrfessors.departments = JSON.parse($("script#departments").html());
		RateMyPurrfessors.gradYears = JSON.parse($("script#grad_years").html());
		RateMyPurrfessors.grades = JSON.parse($("script#grades").html());
		var user = JSON.parse($("script#current_user").html());
		RateMyPurrfessors.currentUser = new RateMyPurrfessors.Models.User(user);
		
		var header = new RateMyPurrfessors.Views.Header();
		$("header").html(header.render().$el);
		
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
