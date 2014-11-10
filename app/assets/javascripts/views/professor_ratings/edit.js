RateMyPurrfessors.Views.ProfessorRatingEdit = Backbone.CompositeView.extend({
	initialize: function () {
		this.listenTo(this.model, "sync", this.render);
	},
	
	template: JST["professor_ratings/edit"],
	
	render: function () {
		if (this.model.get("professor")) {
			var that = this
			var professor = new RateMyPurrfessors.Models.Professor({ id: that.model.get("professor").id });
			
			professor.fetch({
				success: function () {
					that.professor = professor;
					var college = RateMyPurrfessors.colleges.get(that.model.get("professor").college_id);
					var renderedContent = that.template({
						professor: that.professor,
						college: college
					});
					that.$el.html(renderedContent);
	
					that.renderForm();
					that.addValues();
				}
			});
		}
		
		return this;
	},
	
	renderForm: function () {
		var formView = new RateMyPurrfessors.Views.ProfessorRatingsForm({
			professor: this.professor,
			action: "api/professor_ratings/" + this.model.get("id"),
			method: "PUT",
			model: this.model
		});
		
		$("div.form").html(formView);
		
		this.addSubview("div.form", formView);
	},
	
	addValues: function () {
		var rating = this.model;
		
		this.$("input#course_code").val(rating.escape("course_code"));
		
		if (rating.get("online_class")) {
			this.$("input#online_class").attr("checked", "checked");
		}
		
		this.$('input[name="professor_rating[helpfulness]"][value="' + rating.get("helpfulness") + '"]').attr("checked", "checked");
		this.$('input[name="professor_rating[clarity]"][value="' + rating.get("clarity") + '"]').attr("checked", "checked");
		this.$('input[name="professor_rating[easiness]"][value="' + rating.get("easiness") + '"]').attr("checked", "checked");
		
		if (!rating.get("taken_for_credit")) {
			this.$("input#taken_for_credit").attr("checked", "checked");
		}
		
		if (rating.get("hotness")) {
			this.$("input#hotness").attr("checked", "checked");
		}
		
		this.$('textarea#comments').text(rating.escape("comments"));
		
		if (rating.get("attendance_is_mandatory")) {
			this.$("input#attendance").attr("checked", "checked");
		}
		
		this.$('input[name="professor_rating[interest]"][value="' + rating.get("interest") + '"]').attr("checked", "checked");
		this.$('input[name="professor_rating[textbook_use]"][value="' + rating.get("textbook_use") + '"]').attr("checked", "checked");
		
		this.$('option[value="' + rating.get("grade_received") + '"]').attr("selected", "selected");
	}
});