data "template_file" "user_data" {
    template = "${file("templates/user_data.tpl")}"

    vars = {
        bucket_name = var.bucket_name
        html_name   = var.html_name
    }
}