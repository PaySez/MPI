$(document).ready(function() {

	$(document).on("click", "#js_link-more-filter", function(e) {
		$(".more-filter-options").slideToggle();
	});

	$(document).on("click", "#expireLink", function(e) {
		$("#js_expire-link-input").slideToggle();
		$("#js_expire-link-datepicker").prop("disabled", !$(this).is(":checked")).val("");
	});

	$(document).on("click", "#shareEmail", function(e) {
		$("#js_send-email-input").toggle();
		$("#js_send-email-input").prop("disabled", !$(this).is(":checked")).val("");
	});

	$(document).on("click", "#personalizeLink", function(e) {
		$("#js_peronsalize-link-container").toggle();
		$("#js_peronsalize-link-container input").prop("disabled", !$(this).is(":checked")).val("");
	});

	$(document).on("click", ".js_copy-link", function(e) {
		var element = $(this).closest(".form-group").find("input");
		element.select();      
    	document.execCommand("copy");
    	var btn = $(this);
    	btn.text("Copied").prop('disabled', true).delay(500).promise().then(function() {
    		btn.text("Copy Link").prop('disabled', false);
    	});
	});

	$("#js_expire-link-datepicker").daterangepicker({
		drops: "up",
		minDate: new Date(),
		maxDate: moment().add(90, "days"),
		showDropdowns: true,
		singleDatePicker: true,
		timePicker: true,
		autoUpdateInput: false
	}).on("apply.daterangepicker",  function(ev, picker){
		$("#js_expire-link-datepicker").val(picker.startDate.format("YYYY-MM-DD HH:mm"));
	});

	$(".js_link-datepicker").daterangepicker({
		locale: {
			cancelLabel: "Clear",
		},
		ranges: {
			"Today": [moment(), moment()],
			"Yesterday": [moment().subtract(1, "days"), moment().subtract(1, "days")],
			"This Week": [moment().startOf("week"), moment().endOf("week")],
			"Last Week": [
				moment().subtract(1, "weeks").startOf("week"),
				moment().subtract(1, "weeks").endOf("week"),
			],
			"This Month": [moment().startOf("month"), moment().endOf("month")],
			"Last Month": [
				moment().subtract(1, "months").startOf("month"),
				moment().subtract(1, "months").endOf("month"),
			],
			"This Year": [moment().startOf("year"), moment().endOf("year")]
		},
	}).on("apply.daterangepicker",  function(ev, picker){
		$('.js_link-datepicker input[name="from_date"]').val(picker.startDate.format("YYYY-MM-DD HH:mm:ss"));
		$('.js_link-datepicker input[name="to_date"]').val(picker.endDate.format("YYYY-MM-DD HH:mm:ss"));
		if(typeof options.apply === "function") {
			options.apply(ev, picker);
		}
	}).on("cancel.daterangepicker",  function() {
		$('.js_link-datepicker input[name="from_date"]').val("");
		$('.js_link-datepicker input[name="to_date"]').val("");
		if(typeof options.cancel === "function") {
			options.cancel();
		}
	});
	$('.js_link-datepicker  input[name="from_date"]').on("keypress keydown keyup", function(e) {
		e.preventDefault();
		return false;
	});
	$('.js_link-datepicker input[name="to_date"]').on("keypress keydown keyup", function(e) {
		e.preventDefault();
		return false;
	});

	initCreateLinkForm();
});

function initCreateLinkForm() {
	validateForm("#js_create-link-form", {});
	var formEl = $("#js_create-link-form");
	var btnEl = $("#js_create-link-submit-btn");
	formEl.on("submit", function(e){
		if (formEl.valid()) {
			btnEl.addClass("disabled running");
			setTimeout(function() {
				btnEl.removeClass("disabled running");
				Swal.fire({
				  icon: 'success',
				  title: 'Success',
				  text: 'Link Created Successfully'
				})
			}, 2000);
		}
		return false;
	});
}

function validateForm(formEl,rules) {
	$(formEl).validate({
		ignore: [],
		focusInvalid: false,
		highlight: function(element) {
			if ($(element).parent(".hidden-group").length ||
				$(element).parent(".select-group").length) {
				$(element).parent().addClass("is-invalid");
			} else {
				$(element).addClass("is-invalid");
			}
			$(element).closest(".form-group").addClass("has-error");
		},
		unhighlight: function(element) {
			if ($(element).parent(".hidden-group").length ||
				$(element).parent(".select-group").length) {
				$(element).parent().removeClass("is-invalid");
			} else {
				$(element).removeClass("is-invalid");
			}
			const formGroup = $(element).closest(".form-group");
			formGroup.find(".invalid-feedback").remove();
			formGroup.removeClass("has-error");
		},
		errorElement: "span",
		errorClass: "invalid-feedback",
		errorPlacement: function(error, element) {
			if (element.parent(".input-group").length) {
				error.insertAfter(element.parent());
			} else if (element.parent(".hidden-group").length ||
				element.parent(".select-group").length ||
				element.parent(".icon-group").length) {
				error.insertAfter(element.parent());
			} else {
				error.insertAfter(element);
			}
		},
		rules: rules,
	});
}