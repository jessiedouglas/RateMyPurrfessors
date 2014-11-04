RateMyPurrfessors.Collections.Colleges = Backbone.Collection.extend({
	url: "api/colleges",
	model: RateMyPurrfessors.Models.College,
	
	getOrFetch: function (id) {
		var college = this.get(id);
		
		if (college) {
			college.fetch();
		} else {
			college = new RateMyPurrfessors.Models.College({ id: id });
			college.fetch({
				success: function () {
					this.add(college);
				}.bind(this)
			});
		}
		
		return college;
	}
});