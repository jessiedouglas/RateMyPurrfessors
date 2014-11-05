RateMyPurrfessors.Views.Home = Backbone.View.extend({
	template: JST["root/home"],
	
	render: function () {
		var renderedContent = this.template();
		this.$el.html(renderedContent);
		
		return this;
	}
});