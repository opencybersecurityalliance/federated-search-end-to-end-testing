from behave import given, when, then
import os

def run_huntbook(context, huntbook_name):
    huntflow_file =  os.path.join('huntbooks', huntbook_name)
    with open(huntflow_file, 'r') as hff:
        huntflow = hff.read()
    context.session.execute(huntflow)

@when(u'I apply the docker domainnamelookup analysis on the network traffic from suspicious processes')
def step_impl(context):
    run_huntbook(context, 'kestrel-before-analytics.hf')
    run_huntbook(context, 'kestrel-analytics.hf')


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

@then(u'derive new Kestrel variable that captures Amazon traffic')
def step_impl(context):
    amazon_traffic = context.session.get_variable('amazon_traffic')
    print(f'len(amazon_traffic) = {len(amazon_traffic)}')
    assert amazon_traffic and len(amazon_traffic) == 4

@then(u'derive new Kestrel variable that captures Akamai traffic')
def step_impl(context):
    akamai_traffic = context.session.get_variable('akamai_traffic')
    print(f'len(akamai_traffic) = {len(akamai_traffic)}')
    assert akamai_traffic and len(akamai_traffic) == 4

@then(u'derive new Kestrel variable that captures Cloudflare traffic')
def step_impl(context):
    cloudflare_traffic = context.session.get_variable('cloudflare_traffic')
    print(f'len(cloudflare_traffic) = {len(cloudflare_traffic)}')
    assert cloudflare_traffic and len(cloudflare_traffic) == 2

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