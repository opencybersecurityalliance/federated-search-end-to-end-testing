from behave import given, when, then
import os

def run_huntbook(context, huntbook_name):
    huntflow_file =  os.path.join('huntbooks', huntbook_name)
    with open(huntflow_file, 'r') as hff:
        huntflow = hff.read()
    context.session.execute(huntflow)
    
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


@when(u'I start a cross-host campaign discovery with Kestrel')
def step_impl(context):
    run_huntbook(context, 'kestrel-cross-host-campaign-discovery.hf')


@then(u'I should find successful attacks led by phishing activities')
def step_impl(context):
    phishing_candidates = context.session.get_variable('phishing_candidates')
    assert phishing_candidates and len(phishing_candidates) == 2
    cmd = context.session.get_variable('cmd')
    assert cmd and len(cmd) == 1


@then(u'reveal malicious activities on compromised host')
def step_impl(context):
    cmd_activities = context.session.get_variable('cmd_activities')
    assert cmd_activities and len(cmd_activities) == 2
    psh_activities = context.session.get_variable('psh_activities')
    assert psh_activities and len(psh_activities) == 1
    splunkd_activities = context.session.get_variable('splunkd_activities')
    assert splunkd_activities and len(splunkd_activities) == 20


@then(u'identify hosts targetted in lateral movement by the attacker')
def step_impl(context):
    lateral_mov_win = context.session.get_variable('lateral_mov_win')
    assert lateral_mov_win and len(lateral_mov_win) == 1
    lateral_mov_win_nt = context.session.get_variable('lateral_mov_win_nt')
    assert lateral_mov_win_nt and len(lateral_mov_win_nt) == 3
    lateral_mov_112_nt = context.session.get_variable('lateral_mov_112_nt')
    assert lateral_mov_112_nt and len(lateral_mov_112_nt) == 3
    lateral_mov_112_receiver = context.session.get_variable('lateral_mov_112_receiver')
    assert lateral_mov_112_receiver and len(lateral_mov_112_receiver) == 1
    splunkd_on_112 = context.session.get_variable('splunkd_on_112')
    assert splunkd_on_112 and len(splunkd_on_112) == 1
    splunkd_activities_on_112 = context.session.get_variable('splunkd_activities_on_112')
    assert splunkd_activities_on_112 and len(splunkd_activities_on_112) == 20
    lateral_mov_linux = context.session.get_variable('lateral_mov_linux')
    assert lateral_mov_linux and len(lateral_mov_linux) == 1
    lateral_mov_linux_nt = context.session.get_variable('lateral_mov_linux_nt')
    assert lateral_mov_linux_nt and len(lateral_mov_linux_nt) == 1
    lateral_mov_91_nt = context.session.get_variable('lateral_mov_91_nt')
    assert lateral_mov_91_nt and len(lateral_mov_91_nt) == 1
    # linux_proc = context.session.get_variable('linux_proc')
    # assert linux_proc and len(linux_proc) == 1