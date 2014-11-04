window.RateMyPurrfessors = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    RateMyPurrfessors.colleges = new RateMyPurrfessors.Collections.Colleges();
		RateMyPurrfessors.colleges.fetch();
		
		RateMyPurrfessors.professors = new RateMyPurrfessors.Collections.Professors({
			college: null
		});
		RateMyPurrfessors.professors.fetch();
		
		new RateMyPurrfessors.Routers.Router();
		Backbone.history.start();
  }
};

$(document).ready(function(){
  RateMyPurrfessors.initialize();
});
