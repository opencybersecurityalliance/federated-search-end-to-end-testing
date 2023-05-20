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


@when(u'I apply the docker domainnamelookup analysis on the network traffic from suspicious processes')
def step_impl(context):
    run_huntbook(context, 'kestrel-before-analytics.hf')
    context.analytics_summary = run_huntbook(context, 'kestrel-analytics.hf')


@then(u'I should see customized attributes x_domain_name and x_domain_organization in network traffic')
def step_impl(context):
    traffic_var = context.session.get_variable('traffic')
    for traffic in traffic_var:
        traffic_attrs = traffic.keys()
        assert ('x_domain_name' in traffic_attrs and
                'x_domain_organization' in traffic_attrs)

@then(u'derive new Kestrel variable that captures Github traffic')
def step_impl(context):
    github_traffic = context.session.get_variable('github_traffic')
    print(f'len(github_traffic) = {len(github_traffic)}')
    assert github_traffic and len(github_traffic) == 2
    github_summary = context.analytics_summary.get('github_traffic', {})
    assert github_summary and github_summary.get('#(RECORDS)') == 4


@then(u'derive new Kestrel variable that captures Amazon traffic')
def step_impl(context):
    amazon_traffic = context.session.get_variable('amazon_traffic')
    print(f'len(amazon_traffic) = {len(amazon_traffic)}')
    assert amazon_traffic and len(amazon_traffic) == 4
    amazon_summary = context.analytics_summary.get('amazon_traffic', {})
    assert amazon_summary and amazon_summary.get('#(RECORDS)') == 10


@then(u'derive new Kestrel variable that captures Akamai traffic')
def step_impl(context):
    akamai_traffic = context.session.get_variable('akamai_traffic')
    print(f'len(akamai_traffic) = {len(akamai_traffic)}')
    assert akamai_traffic and len(akamai_traffic) == 4
    akamai_summary = context.analytics_summary.get('akamai_traffic', {})
    assert akamai_summary and akamai_summary.get('#(RECORDS)') == 8


@then(u'derive new Kestrel variable that captures Cloudflare traffic')
def step_impl(context):
    cloudflare_traffic = context.session.get_variable('cloudflare_traffic')
    print(f'len(cloudflare_traffic) = {len(cloudflare_traffic)}')
    assert cloudflare_traffic and len(cloudflare_traffic) == 2
    cloudflare_summary = context.analytics_summary.get('cloudflare_traffic', {})
    assert cloudflare_summary and cloudflare_summary.get('#(RECORDS)') == 4


@when(u'I get the network traffic from suspicious processes without applying analytics')
def step_impl(context):
    run_huntbook(context, 'kestrel-before-analytics.hf')

@then(u'I should not see x_domain_name and x_domain_organization customized attributes in network traffic')
def step_impl(context):
    traffic_var = context.session.get_variable('traffic')
    for traffic in traffic_var:
        traffic_attrs = traffic.keys()
        assert ('x_domain_name' not in traffic_attrs and
                'x_domain_organization' not in traffic_attrs)