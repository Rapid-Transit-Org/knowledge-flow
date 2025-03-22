package co.rapidtransit.acceptance;

import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectClasspathResource;
import org.junit.platform.suite.api.Suite;

import static io.cucumber.junit.platform.engine.Constants.*;

@Suite
@IncludeEngines("cucumber")
@SelectClasspathResource("features")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "co.rapidtransit.acceptance.steps")
@ConfigurationParameter(key = FILTER_TAGS_PROPERTY_NAME, value = "@acceptance and not @slow")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty,timeline:target/cucumber-timeline")
public class RunCucumberTest {
}
