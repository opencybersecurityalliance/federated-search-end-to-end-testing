from behave import given, when, then
from kestrel.session import Session
import os
import shlex
import subprocess

def run_huntbook(context, huntbook_name):
    huntflow_file =  os.path.join('huntbooks', huntbook_name)
    with open(huntflow_file, 'r') as hff:
        huntflow = hff.read()
    context.session.execute(huntflow)

@given(u'a Kestrel session')
def step_impl(context):
    context.session = Session()
    assert context.session is not None
    
@given(u'a running instance of Elasticsearch')
def step_impl(context):
    ps = subprocess.Popen(shlex.split('sudo docker ps'), stdout=subprocess.PIPE)
    ps_es01 = subprocess.check_output(shlex.split('grep es01test'), stdin=ps.stdout)
    ps.wait()
    es01_output = str(ps_es01, 'UTF-8')
    assert es01_output

@given(u'a huntbook named "kestrel-test.hf"')
def step_impl(context):
    context.huntbook_name = os.path.join('huntbooks', 'kestrel-test.hf')

@when(u'I read with Kestrel the huntbook "kestrel-test.hf"')
def step_impl(context):
    with open(context.huntbook_name, 'r') as hff:
        context.huntflow = hff.read()
    assert context.huntflow

@then(u'I should see the execution results')
def step_impl(context):
    displays = context.session.execute(context.huntflow)
    assert displays

@then(u'close the session')
def step_impl(context):
    context.session.close()
    
@given(u'a hunt statement')
def step_impl(context):
    context.hunt_statement = "procs = GET process FROM stixshifter://bh22-win01 "\
        "WHERE name = 'powershell.exe' "\
        "START 2022-07-01T00:00:00Z STOP 2022-08-01T00:00:00Z"

@when(u'I execute the statement with Kestrel')
def step_impl(context):
    context.results = context.session.execute(context.hunt_statement)
    context.procs = context.session.get_variable('procs')
    assert context.procs

@then(u'I should see the statement execution results')
def step_impl(context):
    assert len(context.procs) == 21


@given(u'a hunt flow')
def step_impl(context):
    context.hunt_flow =  "newvar = GET process FROM stixshifter://bh22-win01 "\
        "WHERE [process:name = 'cmd.exe'] "\
        "START 2022-07-01T00:00:00Z STOP 2022-08-01T00:00:00Z"


@when(u'I execute the hunt flow with Kestrel')
def step_impl(context):
    context.session.execute(context.hunt_flow)


@then(u'I should export the Kestrel variable to python')
def step_impl(context):
    cmds = context.session.get_variable('newvar')
    assert cmds
    
@given(u'a winlogbeats elastic index')
def step_impl(context):
    context.winlogbeats_index_name = 'win-111-winlogbeat-bh22-20220727'


@given(u'a linux sysflow elastic index')
def step_impl(context):
    context.linux_index_name = 'linux-91-sysflow-test-20220725'


@when(u'I start hunt from TTPs with Kestrel')
def step_impl(context):
    run_huntbook(context, 'kestrel-user-processes.hf')
    run_huntbook(context, 'kestrel-local-users.hf')
    run_huntbook(context, 'kestrel-antivirus.hf')
    run_huntbook(context, 'kestrel-lateral-movement.hf')
    run_huntbook(context, 'kestrel-attack-candidates.hf')
    

@then(u'I should find user processes (T1057)')
def step_impl(context):
    t1057_instances = context.session.get_variable('t1057_instances')
    assert t1057_instances and len(t1057_instances) == 1

@then(u'identify local users (T1087.001)')
def step_impl(context):
    t1087_instances = context.session.get_variable('t1087_instances')
    assert t1087_instances and len(t1087_instances) == 1


@then(u'discover antivirus programs (T1518.001)')
def step_impl(context):
    t1518_instances = context.session.get_variable('t1518_instances')
    assert t1518_instances and len(t1518_instances) == 2


@then(u'match multiple related/similar TTPs (T1570 and T1021.006)')
def step_impl(context):
    lateral_movement = context.session.get_variable('lateral_movement')
    assert not lateral_movement
    # assert lateral_movement and len(lateral_movement) == 0


@then(u'identify phishing candidates on windows')
def step_impl(context):
    phishing_candidates = context.session.get_variable('phishing_candidates')
    assert phishing_candidates and len(phishing_candidates) == 2


@then(u'identify exploit candidates on linux')
def step_impl(context):
    exploit_candidates = context.session.get_variable('exploit_candidates')
    assert exploit_candidates and len(exploit_candidates) == 13
