 //skyui.widgets.WidgetBase
class VampireMeterWidget extends skyui.widgets.WidgetBase
{	
  /* STAGE ELEMENTS */
	
	public var VampStageTxt: TextField;
	//public var _meter: MovieClip;
	public var _meterEmptyIdx: Number;
	public var _meterFullIdx: Number;
	public var VampireMeter: MovieClip;
	public var SunIcon: MovieClip;
	
  /* INITIALIZATION */

	public function VampireMeterWidget()
	{
		super();
		_visible = false;
		VampStageTxt.text = "0";
		//VampireMeter.visible = false
		initMeter()
		SunIcon._visible = false;
	}


  /* PUBLIC FUNCTIONS */
  
	// @overrides WidgetBase
	public function getWidth(): Number
	{
		return _width;
	}

	// @overrides WidgetBase
	public function getHeight(): Number
	{
		return _height;
	}
	
	function get Scale()
    {
       return (_xscale);
    }
    function set Scale(scale)
    {
        _xscale = scale;
        _yscale = scale;
        //this.invalidateSize();
        //return (this.Scale());
        null;
    }
	
	// @Papyrus
	public function setVisible(a_visible: Boolean): Void
	{
		_visible = a_visible;
	}
	
	// @Papyrus
	public function setMeterFrame(a_number: Number): Void
	{
		//VampStageTxt.text = String(a_number);
		VampireMeter.gotoAndStop(a_number);
		
	}
	
	public function initMeter(): Void
	{
		VampireMeter.gotoAndStop("Empty");
		var twelve: Number = 12;
		VampireMeter.gotoAndStop(twelve);
	}
	
	// @Papyrus
	public function setStage(a_count: Number): Void
	{
		VampStageTxt.text = String(a_count);
	}
	
	// @Papyrus
	public function setSunVisibility(a_visible: Boolean): Void
	{
		SunIcon._visible = a_visible;
	}
}