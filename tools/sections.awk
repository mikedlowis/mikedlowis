#!/bin/env awk -f

BEGIN {
    mode = 0
    pid = PID
    sectid = 0
    newfile = "section-" sectid "-" pid
    ofile = ""
}

ofile == "" {
    ofile = newfile
    print ofile
}

mode == 0 {
    if (($0 != "") && ($1 != "#")) {
        if ($0 != "---") {
            first = $1
            $1 = ""
            print "export " first "=\"" substr($0, 2) "\"" > ofile
        } else {
            mode = 1
            sectid = sectid + 1
            newfile = "section-" sectid "-" pid
            ofile = ""
        }
    }
}

mode == 1 {
    if ($0 != "---") {
        print $0 > ofile
    } else {
        sectid = sectid + 1
        newfile = "section-" sectid "-" pid
        ofile = ""
    }
}

