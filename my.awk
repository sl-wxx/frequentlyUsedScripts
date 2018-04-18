#! /bin/gawk -f

BEGIN {
    RS=";"
    valuesExp="values\\s*\\(\\s*[0-9]+"
    valuesExpUpper="VALUES\\s*\\(\\s*[0-9]+"
    idExp="\\(\\s*id\\s*,"
    dict["pcic_timer_job"] = "seq_timer_job"
    dict["pcic_icd_map"] = "seq_pcic_icd_map"
    dict["mdi_rest_map"] = "seq_rest_map"
    dict["mdi_rest_router"] = "seq_rest_router"
    dict["pcic_hosiptal_map"] = "seq_pcic_hosiptal_map"
    dict["pcic_large_item_code_map"] = "seq_pcic_large_item_code_map"
}

{
    lowerString = tolower($0)
    if (! needReplace(lowerString)) {
        print $0 ";"
    } else {
        for (tableName in dict) {
            if (lowerString ~ tableName) {
                regexp = "jkjh\\." tableName
                if (lowerString !~ regexp) {
                    print "Error: no owner for table."
                    print $0
                    exit 1
                } else {
                    seq = dict[tableName]
                    sub(valuesExp, "values (" seq ".nextval")
                    sub(valuesExpUpper, "values (" seq ".nextval")
                    print $0 ";"
                    break
                }
            }
        }
    }
}

function needReplace(str) {
    if (str !~ /insert into/) {
        return 0
    }

    if (str !~ idExp) {
        print "Error: id is not the first column for insert."
        print $0
        exit 1
    }

    if(str !~ valuesExp) {
        return 0
    } else {
        return 1
    }
}