resource oci_core_volume_backup_policy gold_bckp_policy {
  compartment_id = var.compartment_ocid
  #destination_region = <<Optional value not found in discovery>>
  display_name = local.gold_policy_name
  freeform_tags = var.freeform_tags
  schedules {
    backup_type       = "INCREMENTAL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_DAY"
    retention_seconds = "604800"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
  schedules {
    backup_type       = "INCREMENTAL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_WEEK"
    retention_seconds = "2419200"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
  schedules {
    backup_type       = "INCREMENTAL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_MONTH"
    retention_seconds = "31557600"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
  schedules {
    backup_type       = "FULL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_YEAR"
    retention_seconds = "157680000"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
}

resource oci_core_volume_backup_policy bronze_bckp_policy {
  compartment_id = var.compartment_ocid
  #destination_region = <<Optional value not found in discovery>>
  display_name = local.brz_policy_name
  freeform_tags = var.freeform_tags

  schedules {
    backup_type       = "INCREMENTAL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_MONTH"
    retention_seconds = "31557600"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
  schedules {
    backup_type       = "FULL"
    day_of_month      = "-1"
    day_of_week       = ""
    hour_of_day       = "-1"
    month             = ""
    offset_seconds    = "0"
    offset_type       = ""
    period            = "ONE_YEAR"
    retention_seconds = "157680000"
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
}
