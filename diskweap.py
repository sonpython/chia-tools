import shutil
import sys
import glob
import os

# Reorganizing chia plot on disk to free disk
# example python diskweap.py /media/plot1
# will check moving all finish plot from disk6 to 1, 5 to 1, 4 to 1, 3 to 1, 2 to 1 then step to disk 2 => 6 to 2...

mount_path = sys.argv[1]
disk_list = glob.glob('{}/*/'.format(mount_path))
disk_details = []
for d in disk_list:
    total, used, free = shutil.disk_usage(d)
    disk_details.append({
        'disk': d,
        'used': used
    })
sorted_disk_details = sorted(disk_details, key=lambda k: k['used'], reverse=True)
print(sorted_disk_details)
list_disk_sorted = [tmp_d['disk'] for tmp_d in sorted_disk_details]
r = 1
for disk in list_disk_sorted:
    total, used, free = shutil.disk_usage(disk)
    print('==============================================================')
    print('Destination Disk', disk)
    print("Total: %d GiB" % (total // (2 ** 30)))
    print("Used: %d GiB" % (used // (2 ** 30)))
    print("Free: %d GiB" % (free // (2 ** 30)))
    free = free // (2 ** 30)
    i = 1
    print(f'Round {r}, Turn {i}, is free > 103 {free > 103}, Remaining disk {len(list_disk_sorted) - r}')
    while free > 103 and i <= len(list_disk_sorted) - r:
        print('============================')
        source_disk = list_disk_sorted[-i]
        source_disk_plots = glob.glob('{}/*.plot'.format(source_disk))
        p = 1
        print(f'source_disk {source_disk}, plot_num {len(source_disk_plots)}')
        try:
            for plot in source_disk_plots:
                p += 1
                plot_size = os.path.getsize(plot)
                # only copy done plot bigger than 108600000000
                total, used, free = shutil.disk_usage(disk)
                free = free // (2 ** 30)
                print(
                    f'Round {r}, Turn {i}, Plot {p}, is free > 103 {free > 103}, Remaining disk {len(list_disk_sorted) - r}, Remaining plot {len(source_disk_plots) - p}')
                if plot_size > 108600000000 and free > 103:
                    print('Found valid plot', plot_size, plot)
                    print(f'Moving from {source_disk} to {disk}')
                    # print(plot, f'{disk}/{os.path.split(plot)[-1]}')
                    destination = f'{disk}{os.path.split(plot)[-1]}'
                    # os.replace(plot, destination)  # slow speed, does not support cross devices
                    # os.system(f'mv {plot} {destination}')  # fastest speed
                    print(shutil.move(plot, destination))  # slow speed, safe
                    # move to destination disk
                    # print(plot, destination)
        except Exception as e:
            print(e)
        i += 1
    r += 1
