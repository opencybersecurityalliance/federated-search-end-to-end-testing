from behave import given, when, then
import os

def run_huntbook(context, huntbook_name):
    huntflow_file =  os.path.join('huntflows', huntbook_name)
    summary_vars_dict = {}
    with open(huntflow_file, 'r') as hff:
        huntflow = hff.read()
    summary = context.session.execute(huntflow)
    for ixx in range(len(summary)):
        summary_dict = summary[ixx].to_dict()
        summary_data = summary_dict['data']
        if type(summary_data) is dict:
            summary_vars_list = summary_data.get('variables updated', [])
            summary_vars_dict.update(
                { x['VARIABLE']: x for x in summary_vars_list }
            )
    return summary_vars_dict


@given(u'a winlogbeat elastic index')
def step_impl(context):
    context.winlogbeats_index_name = 'win-111-winlogbeat-bh22-20220727'


@given(u'a linux sysflow elastic index')
def step_impl(context):
    context.linux_index_name = 'linux-91-sysflow-test-20220725'


@when(u'I start hunt from TTPs with Kestrel')
def step_impl(context):
    context.summary_hunt_ttps = run_huntbook(
        context, 'kestrel-start-hunt-from-ttps.hf')

@then(u'I should find user processes (T1057)')
def step_impl(context):
    t1057_instances = context.session.get_variable('t1057_instances')
    assert t1057_instances and len(t1057_instances) == 1
    t1057_summary = context.summary_hunt_ttps.get('t1057_instances', {})
    assert t1057_summary and t1057_summary.get('#(RECORDS)') == 3

@then(u'identify local users (T1087.001)')
def step_impl(context):
    t1087_instances = context.session.get_variable('t1087_instances')
    assert t1087_instances and len(t1087_instances) == 1
    t1087_summary = context.summary_hunt_ttps.get('t1087_instances', {})
    assert t1087_summary and t1087_summary.get('#(RECORDS)') == 3


@then(u'discover antivirus programs (T1518.001)')
def step_impl(context):
    t1518_instances = context.session.get_variable('t1518_instances')
    print(f'len(t1518_instances) = {len(t1518_instances)}')
    assert t1518_instances and len(t1518_instances) == 3
    t1518_summary = context.summary_hunt_ttps.get('t1518_instances', {})
    assert t1518_summary and t1518_summary.get('#(RECORDS)') == 11


@then(u'match multiple related/similar TTPs (T1570 and T1021.006)')
def step_impl(context):
    lateral_movement = context.session.get_variable('lateral_movement')
    print(f'len(lateral_movement) = {len(lateral_movement)}')
    # assert not lateral_movement
    assert lateral_movement and len(lateral_movement) == 2
    lat_move_summary = context.summary_hunt_ttps.get('lateral_movement', {})
    assert lat_move_summary and lat_move_summary.get('#(RECORDS)') == 10


@then(u'identify phishing candidates on windows')
def step_impl(context):
    phishing_candidates = context.session.get_variable('phishing_candidates')
    assert phishing_candidates and len(phishing_candidates) == 2
    phish_summary = context.summary_hunt_ttps.get('phishing_candidates', {})
    assert phish_summary and phish_summary.get('#(RECORDS)') == 15


@then(u'identify exploit candidates on linux')
def step_impl(context):
    exploit_candidates = context.session.get_variable('exploit_candidates')
    print(f'len(exploit_candidates) = {len(exploit_candidates)}')
    assert exploit_candidates and len(exploit_candidates) in [718, 964]
    exploit_summary = context.summary_hunt_ttps.get('exploit_candidates', {})
    assert exploit_summary and exploit_summary.get('#(RECORDS)') == 718


@when(u'I start a cross-host campaign discovery with Kestrel')
def step_impl(context):
    context.campaign_summary = run_huntbook(
        context, 'kestrel-cross-host-campaign-discovery.hf')


@then(u'I should find successful attacks led by phishing activities')
def step_impl(context):
    phishing_candidates = context.session.get_variable('phishing_candidates')
    assert phishing_candidates and len(phishing_candidates) == 2
    phish_summary = context.campaign_summary.get('phishing_candidates', {})
    assert phish_summary and phish_summary.get('#(RECORDS)') == 15
    cmd = context.session.get_variable('cmd')
    assert cmd and len(cmd) == 1
    cmd_summary = context.campaign_summary.get('cmd', {})
    assert cmd_summary and cmd_summary.get('#(RECORDS)') == 5


@then(u'reveal malicious activities on compromised host')
def step_impl(context):
    cmd_activities = context.session.get_variable('cmd_activities')
    assert cmd_activities and len(cmd_activities) == 2
    cmd_activ_summary = context.campaign_summary.get('cmd_activities', {})
    assert cmd_activ_summary and cmd_activ_summary.get('#(RECORDS)') == 8
    psh_activities = context.session.get_variable('psh_activities')
    assert psh_activities and len(psh_activities) == 1
    psh_activ_summary = context.campaign_summary.get('psh_activities', {})
    assert psh_activ_summary and psh_activ_summary.get('#(RECORDS)') == 36
    splunkd_activities = context.session.get_variable('splunkd_activities')
    assert splunkd_activities and len(splunkd_activities) == 20
    splunkd_activ_summary = context.campaign_summary.get('splunkd_activities', {})
    assert splunkd_activ_summary and splunkd_activ_summary.get('#(RECORDS)') == 76


@then(u'identify hosts targetted in lateral movement by the attacker')
def step_impl(context):
    lateral_mov_win = context.session.get_variable('lateral_mov_win')
    assert lateral_mov_win and len(lateral_mov_win) == 1
    lm_win_summary = context.campaign_summary.get('lateral_mov_win', {})
    assert lm_win_summary and lm_win_summary.get('#(RECORDS)') == 6
    lateral_mov_win_nt = context.session.get_variable('lateral_mov_win_nt')
    assert lateral_mov_win_nt and len(lateral_mov_win_nt) == 3
    lm_win_nt_summary = context.campaign_summary.get('lateral_mov_win_nt', {})
    assert lm_win_nt_summary and lm_win_nt_summary.get('#(RECORDS)') == 3
    lateral_mov_112_nt = context.session.get_variable('lateral_mov_112_nt')
    assert lateral_mov_112_nt and len(lateral_mov_112_nt) == 3
    lm_112_nt_summary = context.campaign_summary.get('lateral_mov_112_nt', {})
    assert lm_112_nt_summary and lm_112_nt_summary.get('#(RECORDS)') == 6
    lateral_mov_linux = context.session.get_variable('lateral_mov_linux')
    assert lateral_mov_linux and len(lateral_mov_linux) == 1
    lm_linux_summary = context.campaign_summary.get('lateral_mov_linux', {})
    assert lm_linux_summary and lm_linux_summary.get('#(RECORDS)') == 9
    lateral_mov_linux_nt = context.session.get_variable('lateral_mov_linux_nt')
    assert lateral_mov_linux_nt and len(lateral_mov_linux_nt) == 1
    lm_linux_nt_summary = context.campaign_summary.get('lateral_mov_linux_nt', {})
    assert lm_linux_nt_summary and lm_linux_nt_summary.get('#(RECORDS)') == 2
    lateral_mov_91_nt = context.session.get_variable('lateral_mov_91_nt')
    assert lateral_mov_91_nt and len(lateral_mov_91_nt) == 1
    lm_91_nt_summary = context.campaign_summary.get('lateral_mov_91_nt', {})
    assert lm_91_nt_summary and lm_91_nt_summary.get('#(RECORDS)') == 1


@then(u'identify attacker activities on windows hosts')
def step_impl(context):
    lateral_mov_112_proc = context.session.get_variable('lateral_mov_112_proc')
    assert lateral_mov_112_proc and len(lateral_mov_112_proc) == 1
    lm_112_mov_summary = context.campaign_summary.get('lateral_mov_112_proc', {})
    assert lm_112_mov_summary and lm_112_mov_summary.get('#(RECORDS)') == 14
    lateral_mov_112_receiver = context.session.get_variable('lateral_mov_112_receiver')
    assert lateral_mov_112_receiver and len(lateral_mov_112_receiver) == 1
    splunkd_on_112 = context.session.get_variable('splunkd_on_112')
    assert splunkd_on_112 and len(splunkd_on_112) == 1
    splunkd_112_summary = context.campaign_summary.get('splunkd_on_112', {})
    assert splunkd_112_summary and splunkd_112_summary.get('#(RECORDS)') == 126
    splunkd_activities_on_112 = context.session.get_variable('splunkd_activities_on_112')
    assert splunkd_activities_on_112 and len(splunkd_activities_on_112) == 20
    splunkd_activ_112_summary = context.campaign_summary.get('splunkd_activities_on_112', {})
    assert splunkd_activ_112_summary and splunkd_activ_112_summary.get('#(RECORDS)') == 172


@then(u'identify attacker activities on linux hosts')
def step_impl(context):
    linux_proc = context.session.get_variable('linux_proc')
    print(f'len(linux_proc) = {len(linux_proc)}')
    assert linux_proc and len(linux_proc) in [34, 35]
    linux_proc_summary = context.campaign_summary.get('linux_proc', {})
    assert linux_proc_summary and linux_proc_summary.get('#(RECORDS)') == 34
    node_children = context.session.get_variable('node_children')
    node_grand_children = context.session.get_variable('node_grand_children')
    print(f'len(node_children) = {len(node_children)}')
    print(f'len(node_grand_children) = {len(node_grand_children)}')
    assert node_children and len(node_children) in [303, 335]
    assert node_grand_children and len(node_grand_children) in [363, 534]
    node_children_summary = context.campaign_summary.get('node_children', {})
    assert node_children_summary and node_children_summary.get('#(RECORDS)') == 303
    node_grand_children_summary = context.campaign_summary.get('node_grand_children', {})
    assert node_grand_children_summary and node_grand_children_summary.get('#(RECORDS)') == 363


@then(u'discover the C2 host / IP address if any')
def step_impl(context):
    c2_traffic = context.session.get_variable('c2_traffic')
    print(f'len(c2_traffic) = {len(c2_traffic)}')
    assert c2_traffic and len(c2_traffic) == 2
    c2_traffic_summary = context.campaign_summary.get('c2_traffic', {})
    assert c2_traffic_summary and c2_traffic_summary.get('#(RECORDS)') == 4
