RateMyPurrfessors.Routers.Router = Backbone.Router.extend({
	initialize: function () {
		this.$rootEl = $("main")
	},
	
	routes: {
		"colleges": "collegesIndex",
		"colleges/:id": "collegeShow"
	},
	
	collegesIndex: function () {
		var indexView = new RateMyPurrfessors.Views.CollegesIndex({
			collection: RateMyPurrfessors.colleges
		});
		
		this._swapView(indexView);
	},
	
	collegeShow: function (id) {
		var college = RateMyPurrfessors.colleges.getOrFetch(id);
		var showView = new RateMyPurrfessors.Views.CollegeShow({
			model: college
		});
		
		this._swapView(showView);
	},
	
	_swapView: function (view) {
		this._currentView && this._currentView.remove();
		this._currentView = view;
		this.$rootEl.html(view.render().$el);
	}
});