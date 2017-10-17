from sys import argv
from os import getenv, makedirs, listdir
from os.path import isdir, dirname, realpath, exists, isfile
from subprocess import run, PIPE

jailfiles = ["command.txt", "os.txt", "prep.txt", "root", "env_vars", "features.txt"]

all_features = {"av":["--bind", "/dev/video0"], 
                "gpu":["--bind", "/dev/dri"],
                "pulse":["--bind", "/run/user/1000/pulse:/run/user/host/pulse"], 
                "x11":["--bind", "/tmp/.X11-unix:/tmp/.X11-unix"],
                "usb":["--bind", "/dev/bus/usb"]}


def run_report_status(cmd, debug=False, report=False, 
                      newline_for_errors=False, passthrough=False):
    if(debug):
        if newline_for_errors:
            print("")
        print("debug: executing command: %s" % " ".join(cmd))
        script_result = run(cmd)
    elif passthrough:
        script_result = run(cmd)
    else:
        script_result = run(cmd, stdout=PIPE, stderr=PIPE)

    if script_result.returncode != 0 and report:
        print("Failed")
        exit(1)
    elif report:
        print("Success")

def apply_script_via_nspawn(scriptsdir, destdir, jaildir, script, os, asuser, debug, jailname, newline_for_errors=False):
    full_destdir = jaildir+"/root"+destdir
    if isdir(full_destdir):
        run_report_status(["sudo", "rm", "-rf", full_destdir], debug)

    cmd_copy = ["sudo", "cp", "-LR", 
                scriptsdir,
                jaildir + "/root" + destdir]
    run_report_status(cmd_copy, debug, report=False, newline_for_errors=newline_for_errors)

    cmd = ["sudo", "systemd-nspawn", 
           "-D", jaildir + "/root", 
           "-E", "CONTAINER_USER=" + asuser,
           "-E", "JAIL_NAME=" + jailname,
           "/bin/bash", destdir+"/" + script]
    run_report_status(cmd, debug, report=True, newline_for_errors=newline_for_errors)



def copy_jail_except_home(cpfrom, cpto, debug=False):
    if isdir(cpto + "/root"):
        delete_jail_except_home(cpto, debug)
    else:
        run_report_status(["mkdir", "-p", cpto], debug)
    for f in jailfiles:
        fpath = cpfrom + "/" + f
        if exists(fpath):
            command = ["sudo", "cp", "-R", "--preserve", "--reflink=auto", 
                       fpath, cpto]
            run_report_status(command, debug)

def get_oneliner(filename):
    if isfile(filename):
        with open(filename, "r") as f:
            return f.readline().strip()
    else:
        return None

def write_oneliner(filename, oneline):
    with open(filename, "w") as f:
        if (oneline):
            f.write(oneline)
        else:
            f.write("default")

class Jail:
    def __init__(self, name):
        self.name = name

    @property
    def loc(self):
        return jailer_home + "/jails/" + self.name

    @property
    def fsroot(self):
        return self.loc + "/root"

    @property
    def homeroot(self):
        return self.loc + "/home_dir"

    @property
    def feature_list(self):
        feature_line = self.feature_line
        if feature_line:
            return [ele for ele in feature_line.split("+") if ele != ""]
        else:
            return None

    @property
    def addon_list(self):
        prep_line = self.prep_line
        if prep_line != None:
            return [e for e in prep_line.split("+") if e != ""]
        else:
            return None

    @property
    def feature_line(self):
        return get_oneliner(self.loc + "/features.txt")

    @feature_line.setter
    def feature_line(self, value):
        write_oneliner(self.loc + "/features.txt", value)

    @property
    def prep_line(self):
        return get_oneliner("%s/prep.txt" % self.loc)

    @prep_line.setter
    def prep_line(self, value):
        write_oneliner(self.loc + "/prep.txt", value)

    @property
    def osname(self):
        return get_oneliner(self.loc + "/os.txt")

    @property
    def command_line(self):
        commandfile = "%s/command.txt" % self.loc
        return get_oneliner(commandfile)

    @command_line.setter
    def command_line(self, value):
        write_oneliner(self.loc + "/command.txt", value)

    def delete_except_home(self, debug=False):
        for f in jailfiles:
            cmd = ["sudo" , "rm", "-rf", self.loc + "/" + f]
            run_report_status(cmd, debug)


jailer_home = getenv("JAILER_HOME", getenv("HOME","")+"/.jailer")
jails_root = jailer_home + "/jails"

if not isdir(jailer_home):
    print("==> Performing first time initialization")
    makedirs(jailer_home+"/jails")
    makedirs(jailer_home+"/scripts")

sdir = dirname(realpath(argv[0]))
destdir = "/initscripts" # Directory inside the chroot install scripts are copied to
user = getenv("USER","user")
jail_list = [Jail(j) for j in listdir(jails_root)]



for jail in jail_list:
    if listdir(jail.loc)==[] or \
        (listdir(jail.loc)==["home_dir"] and \
         listdir(jail.loc + "/home_dir") == []):
        print("(Removing empty jail %s)" % jail.loc)
        run_report_status(["sudo", "rm", "-rf", jail.loc])


