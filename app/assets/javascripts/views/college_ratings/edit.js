RateMyPurrfessors.Views.CollegeRatingEdit = Backbone.CompositeView.extend({
	initialize: function () {
		this.listenTo(this.model, "sync", this.render);
	},
	
	template: JST["college_ratings/edit"],
	
	render: function () {
		if (this.model.get("college")) {
			this.college = RateMyPurrfessors.colleges.get(this.model.get("college").id);
			var renderedContent = this.template({
				college: this.college
			});
			this.$el.html(renderedContent);
		
			this.renderForm();
			this.addValues();
		}
		
		return this;
	},
	
	renderForm: function () {
		var formView = new RateMyPurrfessors.Views.CollegeRatingsForm({
			model: this.model,
			action: "api/college_ratings/" + this.model.get("id"),
			method: "PUT",
			college: this.college,
			cancelUrl: "#/users/" + RateMyPurrfessors.currentUser.get("id")
		});
		
		$("div.form").html(formView);
		
		this.addSubview("div.form", formView);
	},
	
	addValues: function () {
		var rating = this.model
		
		this.$('input[name="college_rating[reputation]"][value="' + rating.get("reputation") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[location]"][value="' + rating.get("location") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[opportunities]"][value="' + rating.get("opportunities") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[library]"][value="' + rating.get("library") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[grounds_and_common_areas]"][value="' + rating.get("grounds_and_common_areas") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[internet]"][value="' + rating.get("internet") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[food]"][value="' + rating.get("food") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[clubs]"][value="' + rating.get("clubs") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[social]"][value="' + rating.get("social") + '"]').attr("checked", "checked");
		this.$('input[name="college_rating[happiness]"][value="' + rating.get("happiness") + '"]').attr("checked", "checked");
		this.$("textarea#comments").text(rating.get("comments"));
		this.$('option[value="' + rating.get("graduation_year") + '"]').attr("selected", "selected");
	}
});