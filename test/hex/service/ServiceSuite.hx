package hex.service;

import hex.service.stateful.StatefulSuite;
import hex.service.stateless.StatelessSuite;

/**
 * ...
 * @author Francis Bourre
 */
class ServiceSuite
{
	@suite("Service suite")
    public var list : Array<Class<Dynamic>> = [StatelessSuite, StatefulSuite, AbstractServiceTest, ServiceConfigurationTest, ServiceEventTest, ServiceURLConfigurationTest];
}