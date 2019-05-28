var barChartBinding = new Shiny.InputBinding();

$.extend(barChartBinding, {
	find: function(scope) {
		return $(scope).find(".amBarChart");
	},
	getValue: function(el) {
		return $(el).data("data");
	},
	getType: function(el) {
		return "dataframe";
	},
	subscribe: function(el, callback) {
		$(el).on("change.barChartBinding", function(e) {
			callback();
		});
	},
	unsubscribe: function(el) {
		$(el).off(".barChartBinding");
	},
	initialize: function(el) {

		var id = el.getAttribute("id");
		var $el = $(el);
		var data = $el.data("data");
		var dataCopy = $el.data("data");
		var categoryField = $el.data("category");
		var valueField = $el.data("value");
		if (!(valueField instanceof Array)) {
			valueField = [valueField];
		}
		var valueNames = $el.data("valuenames");
		if (!(valueNames instanceof Array)) {
			valueNames = [valueNames];
		}
		var minValue = $el.data("min");
		var maxValue = $el.data("max");
		var columnStyle = $el.data("columnstyle");
		if (!(columnStyle.fill instanceof Array)){
		  columnStyle.fill = [columnStyle.fill];
		}
		var columnWidth = $el.data("columnwidth");
		var xAxis = $el.data("xaxis");
		var yAxis = $el.data("yaxis");
		var valueFormatter = $el.data("valueformatter");
		var chartTitle = $el.data("charttitle");
		var theme = $el.data("theme");
		var chartBackgroundColor = $el.data("chartbackgroundcolor");
		var legend = $el.data("legend");
		var draggable = $el.data("draggable");
		if (!(draggable instanceof Array)) {
			draggable = [draggable];
		}
		var chartCaption = $el.data("caption");
		var gridLines = $el.data("gridlines");


		/* ~~~~\  theme  /~~~~ */
		if (theme !== null) {
			if (theme === "dataviz") {
				am4core.useTheme(am4themes_dataviz);
			} else if (theme === "material") {
				am4core.useTheme(am4themes_material);
			} else if (theme === "kelly") {
				am4core.useTheme(am4themes_kelly);
			} else if (theme === "dark") {
				am4core.useTheme(am4themes_dark);
			} else if (theme === "frozen") {
				am4core.useTheme(am4themes_frozen);
			} else if (theme === "moonrisekingdom") {
				am4core.useTheme(am4themes_moonrisekingdom);
			} else if (theme === "spiritedaway") {
				am4core.useTheme(am4themes_spiritedaway);
			}
		}
		am4core.useTheme(am4themes_animated);

		/* ~~~~\  create chart  /~~~~ */
		var chart = am4core.create(id, am4charts.XYChart);
		chart.hiddenState.properties.opacity = 0; // this makes initial fade in effect
		chart.data = data;
		chart.padding(50, 40, 0, 10);
		chart.maskBullets = false; // allow bullets to go out of plot area
		chartBackgroundColor = chartBackgroundColor || chart.background.fill;
		chart.background.fill = chartBackgroundColor;

		/* ~~~~\  title  /~~~~ */
		if (chartTitle !== null) {
			var title = chart.plotContainer.createChild(am4core.Label);
			title.text = chartTitle.text;
			title.fill =
			  chartTitle.color || (theme === "dark" ? "#ffffff" : "#000000");
			title.fontSize = chartTitle.fontSize || 22;
			title.fontWeight = "bold";
			title.fontFamily = "Tahoma";
			title.y = -42;
			title.x = -45;
			title.horizontalCenter = "left";
			title.zIndex = 100;
			title.fillOpacity = 1;
		}

    /* ~~~~\  caption  /~~~~ */
    if (chartCaption !== null) {
      var caption = chart.chartContainer.createChild(am4core.Label);
      caption.text = chartCaption.text;
      caption.fill =
        chartCaption.color || (theme === "dark" ? "#ffffff" : "#000000");
      caption.align = chartCaption.align || "right";
    }

		/* ~~~~\  category axis  /~~~~ */
		var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
		categoryAxis.renderer.grid.template.location = 0;
		categoryAxis.renderer.cellStartLocation = 0.1;
		categoryAxis.renderer.cellEndLocation = 0.9;
		categoryAxis.title.text = xAxis.title.text || categoryField;
		categoryAxis.title.fontWeight = "bold";
		categoryAxis.title.fontSize = xAxis.title.fontSize || 20;
		categoryAxis.title.fill =
		  xAxis.title.color || (theme === "dark" ? "#ffffff" : "#000000");
		var xAxisLabels = categoryAxis.renderer.labels.template;
		xAxisLabels.fontSize = xAxis.labels.fontSize || 17;
		xAxisLabels.rotation = xAxis.labels.rotation || 0;
		xAxisLabels.fill =
		  xAxis.labels.color || (theme === "dark" ? "#ffffff" : "#000000");
		categoryAxis.dataFields.category = categoryField;
		categoryAxis.renderer.grid.template.disabled = true;
		categoryAxis.renderer.minGridDistance = 50;
		categoryAxis.numberFormatter.numberFormat = valueFormatter;

		/* ~~~~\  value axis  /~~~~ */
		var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
    valueAxis.renderer.grid.template.stroke =
      gridLines.color || (theme === "dark" ? "#ffffff" : "#000000");
    valueAxis.renderer.grid.template.strokeOpacity = gridLines.opacity || 0.15;
    valueAxis.renderer.grid.template.strokeWidth = gridLines.width || 1;
		if (yAxis.title !== null) {
			valueAxis.title.text = yAxis.title.text;
			valueAxis.title.fontWeight = "bold";
			valueAxis.title.fontSize = yAxis.title.fontSize || 20;
			valueAxis.title.fill =
			  yAxis.title.color || (theme === "dark" ? "#ffffff" : "#000000");
		}
		var yAxisLabels = valueAxis.renderer.labels.template;
		yAxisLabels.fontSize = yAxis.labels.fontSize || 17;
		yAxisLabels.rotation = yAxis.labels.rotation || 0;
		yAxisLabels.fill =
		  yAxis.labels.color || (theme === "dark" ? "#ffffff" : "#000000");
		// we set fixed min/max and strictMinMax to true, as otherwise value axis will adjust min/max while dragging and it won't look smooth
		valueAxis.strictMinMax = true;
		valueAxis.min = minValue;
		valueAxis.max = maxValue;
		valueAxis.renderer.minWidth = 60;

    /* ~~~~\  legend  /~~~~ */
    if (legend) {
      chart.legend = new am4charts.Legend();
      chart.legend.useDefaultMarker = false;
      var markerTemplate = chart.legend.markers.template;
      markerTemplate.width = 20;
      markerTemplate.strokeWidth = 1;
      markerTemplate.strokeOpacity = 1;
//      markerTemplate.stroke = am4core.color("#000000"); no effect
    }

		/* ~~~~\  function handling the drag event  /~~~~ */
		function handleDrag(event) {
			var dataItem = event.target.dataItem;
			// convert coordinate to value
			var value = valueAxis.yToValue(event.target.pixelY);
			// set new value
			dataItem.valueY = value;
			// make column hover
			dataItem.column.isHover = true;
			// hide tooltip not to interrupt
			dataItem.column.hideTooltip(0);
			// make bullet hovered (as it might hide if mouse moves away)
			event.target.isHover = true;
		}

		/* ~~~~\  Series  /~~~~ */
		function createSeries(i) {

			var series = chart.series.push(new am4charts.ColumnSeries());
			series.dataFields.categoryX = categoryField;
			series.dataFields.valueY = valueField[i];
			series.name = valueNames[i];
			series.sequencedInterpolation = true;
			series.defaultState.interpolationDuration = 1500;

			/* ~~~~\  tooltip  /~~~~ */
			var tooltip = series.tooltip;
			tooltip.pointerOrientation = "vertical";
			tooltip.dy = 0;
			tooltip.getFillFromObject = false;
			tooltip.background.fill = am4core.color("#101010");
			tooltip.background.fillOpacity = 1;
			tooltip.autoTextColor = false;
			tooltip.label.fill = am4core.color("#FFFFFF");
			tooltip.scale = 1;
			tooltip.background.filters.clear(); // remove tooltip shadow
			tooltip.background.pointerLength = 10;

			/* ~~~~\  label bullet  /~~~~ */
			var labelBullet = new am4charts.LabelBullet();
			series.bullets.push(labelBullet);
			labelBullet.label.text =
				"{valueY.value.formatNumber('" + valueFormatter + "')}";
			labelBullet.strokeOpacity = 0;
			labelBullet.adapter.add("dy", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return -10;
				} else {
					return 10;
				}
			});

			/* ~~~~\  bullet  /~~~~ */
			if(draggable[i]){
  			var bullet = series.bullets.create();
	  		bullet.fill = columnStyle.fill[i];
		  	bullet.stroke =
			    columnStyle.stroke || chart.colors.getIndex(i).saturate(0.7);
  			bullet.strokeWidth = 3;
	  		bullet.opacity = 0; // initially invisible
		  	bullet.defaultState.properties.opacity = 0;
			  // resize cursor when over
  			bullet.cursorOverStyle = am4core.MouseCursorStyle.verticalResize;
	  		bullet.draggable = true;
		  	// create bullet hover state
  			var hoverState = bullet.states.create("hover");
	  		hoverState.properties.opacity = 1; // visible when hovered
		  	// add circle sprite to bullet
			  var circle = bullet.createChild(am4core.Circle);
  			circle.radius = 8;
	  		// while dragging
		  	bullet.events.on("drag", event => {
			  	handleDrag(event);
  			});
	  		// on dragging stop
		  	bullet.events.on("dragstop", event => {
			  	handleDrag(event);
				  var dataItem = event.target.dataItem;
	  			dataItem.column.isHover = false;
	  			event.target.isHover = false;
		  		dataCopy[dataItem.index][valueField[i]] = dataItem.values.valueY.value;
			  	Shiny.setInputValue(id + ":dataframe", dataCopy);
				  Shiny.setInputValue(id + "_change", {
					  index: dataItem.index,
  					category: dataItem.categoryX,
	  				field: valueField[i],
		  			value: dataItem.values.valueY.value
			  	});
  			});
			}

			/* ~~~~\  column template  /~~~~ */
			var columnTemplate = series.columns.template;
			columnTemplate.width = am4core.percent(columnWidth);
			columnTemplate.fill = columnStyle.fill[i];
			columnTemplate.stroke =
			  columnStyle.stroke || chart.colors.getIndex(i).saturate(0.7);
			columnTemplate.strokeOpacity = 1;
			columnTemplate.column.fillOpacity = 0.8;
			columnTemplate.column.strokeWidth = 1;
			columnTemplate.tooltipText = "{valueY}";
			columnTemplate.adapter.add("tooltipY", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return 0;
				} else {
					return -valueAxis.valueToPoint(maxValue - target.dataItem.valueY).y;
				}
			});
			var cr = columnStyle.cornerRadius || 8;
			columnTemplate.column.adapter.add("cornerRadiusTopRight", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return target.isHover ? 2 * cr : cr;
				} else {
					return 0;
				}
			});
			columnTemplate.column.adapter.add("cornerRadiusBottomRight", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return 0;
				} else {
					return target.isHover ? 2 * cr : cr;
				}
			});
			columnTemplate.column.adapter.add("cornerRadiusTopLeft", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return target.isHover ? 2 * cr : cr;
				} else {
					return 0;
				}
			});
			columnTemplate.column.adapter.add("cornerRadiusBottomLeft", (x, target) => {
				if (target.dataItem.valueY > 0) {
					return 0;
				} else {
					return target.isHover ? 2 * cr : cr;
				}
			});
			// columns hover state
			var columnHoverState = columnTemplate.column.states.create("hover");
			// you can change any property on hover state and it will be animated
			columnHoverState.properties.fillOpacity = 1;
			columnHoverState.properties.strokeWidth = 3;
			// show bullet when hovered, and hide label because the tooltip is shown
			columnTemplate.events.on("over", event => {
				var dataItem = event.target.dataItem;
				var itemLabelBullet = dataItem.bullets.getKey(labelBullet.uid);
				itemLabelBullet.fillOpacity = 0;
			});
			// hide bullet when mouse is out, and show label
			columnTemplate.events.on("out", event => {
				var dataItem = event.target.dataItem;
				var itemLabelBullet = dataItem.bullets.getKey(labelBullet.uid);
				itemLabelBullet.fillOpacity = 1;
			});
			if (draggable[i]) {
  			// start dragging bullet even if we hit on column not just a bullet, this will make it more friendly for touch devices
  			columnTemplate.events.on("down", event => {
	  			var dataItem = event.target.dataItem;
		  		var itemBullet = dataItem.bullets.getKey(bullet.uid);
			  	itemBullet.dragStart(event.pointer);
			  });
			  // when columns position changes, adjust minX/maxX of bullets so that we could only dragg vertically
  			columnTemplate.events.on("positionchanged", event => {
	  			var dataItem = event.target.dataItem;
			  	if(dataItem.bullets !== undefined){
  			  	var itemBullet = dataItem.bullets.getKey(bullet.uid);
	  			  var column = dataItem.column;
  		  		itemBullet.minX = column.pixelX + column.pixelWidth / 2;
	  		  	itemBullet.maxX = itemBullet.minX;
  				  itemBullet.minY = 0;
  				  itemBullet.maxY = chart.seriesContainer.pixelHeight;
  				}
  			});
			}

		} // end function createSeries

		for (var i = 0; i < valueField.length; ++i) {
		  createSeries(i);
		}

  	/* ~~~~\  unset theme  /~~~~ */
		if (theme !== null) {
  		if (theme === "dataviz") {
	  		am4core.unuseTheme(am4themes_dataviz);
		  } else if (theme === "material") {
				am4core.unuseTheme(am4themes_material);
  		} else if (theme === "kelly") {
	  		am4core.unuseTheme(am4themes_kelly);
		  } else if (theme === "dark") {
				am4core.unuseTheme(am4themes_dark);
  		} else if (theme === "frozen") {
	  		am4core.unuseTheme(am4themes_frozen);
		  } else if (theme === "moonrisekingdom") {
				am4core.unuseTheme(am4themes_moonrisekingdom);
  		} else if (theme === "spiritedaway") {
	  		am4core.unuseTheme(am4themes_spiritedaway);
		  }
	  }

	}
});

Shiny.inputBindings.register(barChartBinding);
