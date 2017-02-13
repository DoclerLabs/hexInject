package hex.di.mapping;

import hex.di.mapping.MappingConfiguration;

/**
 * ...
 * @author Francis Bourre
 */
class MappingConfigurationTest
{
	var _mappingConfiguration : MappingConfiguration;

    @Before
    public function setUp() : Void
    {
        this._mappingConfiguration = new MappingConfiguration();
    }

    @After
    public function tearDown() : Void
    {
        this._mappingConfiguration = null;
    }
}