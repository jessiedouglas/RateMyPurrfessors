RateMyPurrfessors.Routers.Router = Backbone.Router.extend({
	initialize: function () {
		this.$rootEl = $("main");
	},
	
	routes: {
		"": "home",
		"search": "search",
		"session/new": "sessionNew",
		"users/new": "usersNew",
		"users/:id": "userShow",
		"colleges": "collegesIndex",
		"colleges/:id": "collegeShow",
		"colleges/:id/college_ratings/new": "collegeRatingsNew",
		"college_ratings/:id/edit": "collegeRatingsEdit",
		"professors": "professorsIndex",
		"professors/new": "professorsNew",
		"professors/:id": "professorShow",
		"professors/:id/professor_ratings/new": "professorRatingsNew",
		"professor_ratings/:id/edit": "professorRatingEdit"
	},
	
	home: function () {
		var homeView = new RateMyPurrfessors.Views.Home();
		
		this._swapView(homeView);
	},
	
	search: function () {
		var searchView = new RateMyPurrfessors.Views.Search();
		
		this._swapView(searchView);
	},
	
	sessionNew: function () {
		if (RateMyPurrfessors.currentUser.get("id")) {
			Backbone.history.navigate("#/users/" + RateMyPurrfessors.currentUser.get("id"), {trigger: true});
		} else {
			var newView = new RateMyPurrfessors.Views.SessionNew();
		
			this._swapView(newView);
		}
	},
	
	usersNew: function () {
		if (RateMyPurrfessors.currentUser.get("id")) {
			Backbone.history.navigate("#/users/" + RateMyPurrfessors.currentUser.get("id"), {trigger: true});
		} else {
			var user = new RateMyPurrfessors.Models.User();
			var newView = new RateMyPurrfessors.Views.UsersNew({
				model: user
			});
		
			this._swapView(newView);
		}
	},
	
	userShow: function (id) {
		if (RateMyPurrfessors.currentUser.get("id")) {
			var user = new RateMyPurrfessors.Models.User({ id: id });
			var that = this;
		
			user.fetch({
				success: function () {
					var showView = new RateMyPurrfessors.Views.UserShow({
						model: user
					});
				
					that._swapView(showView);
				}
			});
		} else {
			Backbone.history.navigate("#/session/new", {trigger: true});
		} 
	},
	
	collegesIndex: function () {
		var indexView = new RateMyPurrfessors.Views.CollegesIndex({
			collection: RateMyPurrfessors.colleges
		});
		
		this._swapView(indexView);
	},
	
	collegeShow: function (id) {
		var college = RateMyPurrfessors.colleges.get(id);
		var that = this;
		
		college.fetch({
			success: function () { 
				var showView = new RateMyPurrfessors.Views.CollegeShow({
					model: college
				});
		
				that._swapView(showView);
			}
		});
	},
	
	collegeRatingsNew: function (id) {
		if (RateMyPurrfessors.currentUser.get("id")) {
			var college = RateMyPurrfessors.colleges.get(id);
			var newView = new RateMyPurrfessors.Views.CollegeRatingsNew({
				model: college
			});
		
			this._swapView(newView);
		} else {
			Backbone.history.navigate("#/session/new", {trigger: true});
		}
	},
	
	collegeRatingsEdit: function (id) {
		var that = this;
		var collegeRating = new RateMyPurrfessors.Models.CollegeRating({ id: id });
		collegeRating.fetch({
			success: function () {
				var id = RateMyPurrfessors.currentUser.get("id");
				if (id) {
					if (id === collegeRating.get("rater_id")) {
						var editView = new RateMyPurrfessors.Views.CollegeRatingEdit({
							model: collegeRating
						});
		
						that._swapView(editView);
					} else {
						Backbone.history.navigate("#/users/" + id, {trigger: true});
					}
				} else {
					Backbone.history.navigate("#/session/new", {trigger: true});
				}
			}
		});
	},
	
	professorsIndex: function () {
		var indexView = new RateMyPurrfessors.Views.ProfessorsIndex({
			collection: RateMyPurrfessors.professors
		});
		
		this._swapView(indexView);
	},
	
	professorsNew: function () {
		if (RateMyPurrfessors.currentUser.get("id")) {
			var professor = new RateMyPurrfessors.Models.Professor();
			var newView = new RateMyPurrfessors.Views.ProfessorsNew({
				model: professor
			});
		
			this._swapView(newView);
		} else {
			Backbone.history.navigate("#/session/new", {trigger: true});
		}
	},
	
	professorShow: function (id) {
		var professor = RateMyPurrfessors.professors.getOrFetch(id);
		var showView = new RateMyPurrfessors.Views.ProfessorShow({
			model: professor
		});
		
		this._swapView(showView);
	},
	
	professorRatingsNew: function (id) {
		if (RateMyPurrfessors.currentUser.get("id")) {
			var professor = RateMyPurrfessors.professors.getOrFetch(id);
			var newView = new RateMyPurrfessors.Views.ProfessorRatingsNew({
				model: professor
			});
		
			this._swapView(newView);
		} else {
			Backbone.history.navigate("#/session/new", {trigger: true});
		}
	},
	
	professorRatingEdit: function (id) {
		var that = this;
		var professorRating = new RateMyPurrfessors.Models.ProfessorRating({ id: id });
		professorRating.fetch({
			success: function () {
				var id = RateMyPurrfessors.currentUser.get("id");
				if (id) {
					if (id === professorRating.get("rater_id")) {
						
						var editView = new RateMyPurrfessors.Views.ProfessorRatingEdit({
							model: professorRating
						});
		
						that._swapView(editView);
						
					} else {
						Backbone.history.navigate("#/users/" + id, {trigger: true});
					}
				} else {
					Backbone.history.navigate("#/session/new", {trigger: true});
				}
			}
		});
	},
	
	_swapView: function (view) {
		this._currentView && this._currentView.remove();
		this._currentView = view;
		this.$rootEl.html(view.render().$el);
	}
});