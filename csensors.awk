#!/usr/bin/awk -f

BEGIN {
    DEFAULT_COLOR = "\033[;m";
    NORMAL_COLOR = "\033[1;32m";
    RED           = "\033[1;31m";
    MAGENTA       = "\033[1;35m";

    # CPU_thresholds
    cpu_high = 70;
    cpu_middle = 55;

    # GPU_thresholds
    gpu_high = 80;
    gpu_middle = 70;

    fan_middle = 1820;
    fan_high = 2500;
}

function colorize(temp, mid_trsh, high_trsh) {
    new_color = "";

    temp_number = temp;
    gsub("[^0-9]","",temp_number);
    gsub(".$","",temp_number);

    if(temp_number >= high_trsh)
        new_color = RED;
    else if (temp_number >= mid_trsh)
        new_color = MAGENTA;
    else
        new_color = NORMAL_COLOR;

    return new_color temp DEFAULT_COLOR;
}

/fan/ { $3 = "\t" colorize($3, fan_middle, fan_high); }
/temperature/          { $3 = "\t" colorize($3, cpu_middle, cpu_high); }
/Physical id/   { $4 = "\t" colorize($4, cpu_middle, cpu_high); }

# Too many things called temp1. So shut this off
# Multiple spaces added for alignment here - "\t      ".
# /temp1/         { $2 = "\t      " colorize($2, gpu_middle, gpu_high) " "; }

                 { print; }
