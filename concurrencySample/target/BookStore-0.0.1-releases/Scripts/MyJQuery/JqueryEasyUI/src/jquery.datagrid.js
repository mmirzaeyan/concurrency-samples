/**
 * datagrid - jQuery EasyUI
 * 
 * Copyright (c) 2009-2013 www.jeasyui.com. All rights reserved.
 *
 * Licensed under the GPL or commercial licenses
 * To use it on other terms please contact us: info@jeasyui.com
 * http://www.gnu.org/licenses/gpl.txt
 * http://www.jeasyui.com/license_commercial.php
 * 
 * Dependencies:
 *  panel
 * 	resizable
 * 	linkbutton
 * 	pagination
 * 
 */
(function($){
	var DATAGRID_SERNO = 0;
	
	/**
	 * Get the index of array item, return -1 when the item is not found.
	 */
	function indexOfArray(a,o){
		for(var i=0,len=a.length; i<len; i++){
			if (a[i] == o) return i;
		}
		return -1;
	}
	/**
	 * Remove array item, 'o' parameter can be item object or id field name.
	 * When 'o' parameter is the id field name, the 'id' parameter is valid.
	 */
	function removeArrayItem(a,o,id){
		if (typeof o == 'string'){
			for(var i=0,len=a.length; i<len; i++){
				if (a[i][o] == id){
					a.splice(i, 1);
					return;
				}
			}
		} else {
			var index = indexOfArray(a,o);
			if (index != -1){
				a.splice(index, 1);
			}
		}
	}
	/**
	 * Add un-duplicate array item, 'o' parameter is the id field name, if the 'r' object is exists, deny the action.
	 */
	function addArrayItem(a,o,r){
		for(var i=0,len=a.length; i<len; i++){
			if (a[i][o] == r[o]){return;}
		}
		a.push(r);
	}
	
	function createStyleSheet(parent){
		var cc = parent || $('head');
		var state = $.data(cc[0], 'ss');
		if (!state){
			state = $.data(cc[0], 'ss', {
				cache: {},
				dirty: []
			});
		}
		return {
			add: function(lines){
				var ss = ['<style type="text/css">'];
				for(var i=0; i<lines.length; i++){
					state.cache[lines[i][0]] = {width: lines[i][1]};
				}
				var index = 0;
				for(var s in state.cache){
					var item = state.cache[s];
					item.index = index++;
					ss.push(s + '{width:' + item.width + '}');
				}
				ss.push('</style>');
				$(ss.join('\n')).appendTo(cc);
				setTimeout(function(){
					cc.children('style:not(:last)').remove();
				}, 0);
			},
			getRule: function(index){
				var style = cc.children('style:last')[0];
				var styleSheet = style.styleSheet ? style.styleSheet : (style.sheet || document.styleSheets[document.styleSheets.length-1]);
				var rules = styleSheet.cssRules || styleSheet.rules;
				return rules[index];
			},
			set: function(selector, width){
				var item = state.cache[selector];
				if (item){
					item.width = width;
					var rule = this.getRule(item.index);
					if (rule){
						rule.style['width'] = width;
					}
				}
			},
			remove: function(selector){
				var tmp = [];
				for(var s in state.cache){
					if (s.indexOf(selector) == -1){
						tmp.push([s, state.cache[s].width]);
					}
				}
				state.cache = {};
				this.add(tmp);
			},
			dirty: function(selector){
				if (selector){
					state.dirty.push(selector);
				}
			},
			clean: function(){
				for(var i=0; i<state.dirty.length; i++){
					this.remove(state.dirty[i]);
				}
				state.dirty = [];
			}
		}
	}
	
	
	function setSize(target, param) {
		var opts = $.data(target, 'datagrid').options;
		var panel = $.data(target, 'datagrid').panel;
		
		if (param){
			if (param.width) opts.width = param.width;
			if (param.height) opts.height = param.height;
		}
		
		if (opts.fit == true){
			var p = panel.panel('panel').parent();
			opts.width = p.width();
			opts.height = p.height();
		}
		
		panel.panel('resize', {
			width: opts.width,
			height: opts.height
		});
	}
	
	function setBodySize(target){
		var opts = $.data(target, 'datagrid').options;
		var dc = $.data(target, 'datagrid').dc;
		var wrap = $.data(target, 'datagrid').panel;
		var innerWidth = wrap.width();
		var innerHeight = wrap.height();
		
		var view = dc.view;
		var view1 = dc.view1;
		var view2 = dc.view2;
		var header1 = view1.children('div.datagrid-header');
		var header2 = view2.children('div.datagrid-header');
		var table1 = header1.find('table');
		var table2 = header2.find('table');
		
		// set view width
		view.width(innerWidth);
		var headerInner = header1.children('div.datagrid-header-inner').show();
		view1.width(headerInner.find('table').width());
		if (!opts.showHeader) headerInner.hide();
		view2.width(innerWidth - view1._outerWidth());
		view1.children('div.datagrid-header,div.datagrid-body,div.datagrid-footer').width(view1.width());
		view2.children('div.datagrid-header,div.datagrid-body,div.datagrid-footer').width(view2.width());
		
		// set header height
		var hh;
		header1.css('height', '');
		header2.css('height', '');
		table1.css('height', '');
		table2.css('height', '');
		hh = Math.max(table1.height(), table2.height());
		table1.height(hh);
		table2.height(hh);
		header1.add(header2)._outerHeight(hh);
		
		// set body height
		if (opts.height != 'auto') {
			var height = innerHeight
					- view2.children('div.datagrid-header')._outerHeight()
					- view2.children('div.datagrid-footer')._outerHeight()
					- wrap.children('div.datagrid-toolbar')._outerHeight();
			wrap.children('div.datagrid-pager').each(function(){
				height -= $(this)._outerHeight();
			});
//			view1.children('div.datagrid-body').height(height);
//			view2.children('div.datagrid-body').height(height);
			
			dc.body1.add(dc.body2).children('table.datagrid-btable-frozen').css({
				position: 'absolute',
				top: dc.header2._outerHeight()
			});
			var frozenHeight = dc.body2.children('table.datagrid-btable-frozen')._outerHeight();
			view1.add(view2).children('div.datagrid-body').css({
				marginTop: frozenHeight,
				height: (height - frozenHeight)
			});
		}
		
		view.height(view2.height());
//		view2.css('left', view1._outerWidth());
	}
	
	function fixRowHeight(target, index, forceFix){
		var rows = $.data(target, 'datagrid').data.rows;
		var opts = $.data(target, 'datagrid').options;
		var dc = $.data(target, 'datagrid').dc;
		
		if (!dc.body1.is(':empty') && (!opts.nowrap || opts.autoRowHeight || forceFix)){
			if (index != undefined){
				var tr1 = opts.finder.getTr(target, index, 'body', 1);
				var tr2 = opts.finder.getTr(target, index, 'body', 2);
				setHeight(tr1, tr2);
			} else {
				var tr1 = opts.finder.getTr(target, 0, 'allbody', 1);
				var tr2 = opts.finder.getTr(target, 0, 'allbody', 2);
				setHeight(tr1, tr2);
				if (opts.showFooter){
					var tr1 = opts.finder.getTr(target, 0, 'allfooter', 1);
					var tr2 = opts.finder.getTr(target, 0, 'allfooter', 2);
					setHeight(tr1, tr2);
				}
			}
		}
		
		setBodySize(target);
		if (opts.height == 'auto'){
			var body1 = dc.body1.parent();
			var body2 = dc.body2;
			var csize = getContentSize(body2);
			var height = csize.height;
			if (csize.width > body2.width()){
				height += 18;
			}
			body1.height(height);
			body2.height(height);
			dc.view.height(dc.view2.height());
		}
		dc.body2.triggerHandler('scroll');
		
		// set body row or footer row height
		function setHeight(trs1, trs2){
			for(var i=0; i<trs2.length; i++){
				var tr1 = $(trs1[i]);
				var tr2 = $(trs2[i]);
				tr1.css('height', '');
				tr2.css('height', '');
				var height = Math.max(tr1.height(), tr2.height());
				tr1.css('height', height);
				tr2.css('height', height);
			}
		}
		// get content size of a container(div)
		function getContentSize(cc){
			var width = 0;
			var height = 0;
			$(cc).children().each(function(){
				var c = $(this);
				if (c.is(':visible')){
					height += c._outerHeight();
					if (width < c._outerWidth()){
						width = c._outerWidth();
					}
				}
			});
			return {width:width,height:height};
		}
	}
	
	function freezeRow(target, index){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		if (!dc.body2.children('table.datagrid-btable-frozen').length){
			dc.body1.add(dc.body2).prepend('<table class="datagrid-btable datagrid-btable-frozen" cellspacing="0" cellpadding="0"></table>');
		}
		moveTr(true);
		moveTr(false);
		setBodySize(target);
		function moveTr(frozen){
			var serno = frozen ? 1 : 2;
			var tr = opts.finder.getTr(target, index, 'body', serno);
			(frozen ? dc.body1 : dc.body2).children('table.datagrid-btable-frozen').append(tr);
		}
	}
	
	/**
	 * wrap and return the grid object, fields and columns
	 */
	function wrapGrid(target, rownumbers) {
		function getColumns(){
			var frozenColumns = [];
			var columns = [];
			$(target).children('thead').each(function(){
				var opt = $.parser.parseOptions(this, [{frozen:'boolean'}]);
				$(this).find('tr').each(function(){
					var cols = [];
					$(this).find('th').each(function(){
						var th = $(this);
						var col = $.extend({}, $.parser.parseOptions(this, [
    						'field','align','halign','order',
    						{sortable:'boolean',checkbox:'boolean',resizable:'boolean',fixed:'boolean'},
    						{rowspan:'number',colspan:'number',width:'number'}
    					]), {
    						title: (th.html() || undefined),
    						hidden: (th.attr('hidden') ? true : undefined),
    						formatter: (th.attr('formatter') ? eval(th.attr('formatter')) : undefined),
    						styler: (th.attr('styler') ? eval(th.attr('styler')) : undefined),
    						sorter: (th.attr('sorter') ? eval(th.attr('sorter')) : undefined)
    					});
//    					if (!col.align) col.align = 'left';
    					if (th.attr('editor')){
    						var s = $.trim(th.attr('editor'));
    						if (s.substr(0,1) == '{'){
    							col.editor = eval('(' + s + ')');
    						} else {
    							col.editor = s;
    						}
    					}
    					
    					cols.push(col);
					});
					
					opt.frozen ? frozenColumns.push(cols) : columns.push(cols);
				});
			});
			return [frozenColumns, columns];
		}
		
		var panel = $(
				'<div class="datagrid-wrap">' +
					'<div class="datagrid-view">' +
						'<div class="datagrid-view1">' +
							'<div class="datagrid-header">' +
								'<div class="datagrid-header-inner"></div>' +
							'</div>' +
							'<div class="datagrid-body">' +
								'<div class="datagrid-body-inner"></div>' +
							'</div>' +
							'<div class="datagrid-footer">' +
								'<div class="datagrid-footer-inner"></div>' +
							'</div>' +
						'</div>' +
						'<div class="datagrid-view2">' +
							'<div class="datagrid-header">' +
								'<div class="datagrid-header-inner"></div>' +
							'</div>' +
							'<div class="datagrid-body"></div>' +
							'<div class="datagrid-footer">' +
								'<div class="datagrid-footer-inner"></div>' +
							'</div>' +
						'</div>' +
//						'<div class="datagrid-resize-proxy"></div>' +
					'</div>' +
				'</div>'
		).insertAfter(target);
		
		panel.panel({
			doSize:false
		});
		panel.panel('panel').addClass('datagrid').bind('_resize', function(e, force){
			var opts = $.data(target, 'datagrid').options;
			if (opts.fit == true || force){
				setSize(target);
				setTimeout(function(){
					if ($.data(target, 'datagrid')){
						fixColumnSize(target);
					}
				}, 0);
			}
			return false;
		});
		
		$(target).hide().appendTo(panel.children('div.datagrid-view'));
		
		var cc = getColumns();
		var view = panel.children('div.datagrid-view');
		var view1 = view.children('div.datagrid-view1');
		var view2 = view.children('div.datagrid-view2');
		
		var pview = panel.closest('div.datagrid-view');
		if (!pview.length){pview = view};
		var ss = createStyleSheet(pview);
		
		return {
			panel: panel,
			frozenColumns: cc[0],
			columns: cc[1],
			dc: {	// some data container
				view: view,
				view1: view1,
				view2: view2,
				header1: view1.children('div.datagrid-header').children('div.datagrid-header-inner'),
				header2: view2.children('div.datagrid-header').children('div.datagrid-header-inner'),
				body1: view1.children('div.datagrid-body').children('div.datagrid-body-inner'),
				body2: view2.children('div.datagrid-body'),
				footer1: view1.children('div.datagrid-footer').children('div.datagrid-footer-inner'),
				footer2: view2.children('div.datagrid-footer').children('div.datagrid-footer-inner')
			},
			ss: ss
		};
	}
	
	function buildGrid(target){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		var panel = state.panel;
		
		panel.panel($.extend({}, opts, {
			id: null,
			doSize: false,
			onResize: function(width, height){
				setTimeout(function(){
					if ($.data(target, 'datagrid')){
						setBodySize(target);
						fitColumns(target);
						opts.onResize.call(panel, width, height);
					}
				}, 0);
			},
			onExpand: function(){
				//setBodySize(target);
				fixRowHeight(target);
				opts.onExpand.call(panel);
			}
		}));
		
		state.rowIdPrefix = 'datagrid-row-r' + (++DATAGRID_SERNO);
		state.cellClassPrefix = 'datagrid-cell-c' + DATAGRID_SERNO;
		createColumnHeader(dc.header1, opts.frozenColumns, true);
		createColumnHeader(dc.header2, opts.columns, false);
		createColumnStyle();
		
		dc.header1.add(dc.header2).css('display', opts.showHeader ? 'block' : 'none');
		dc.footer1.add(dc.footer2).css('display', opts.showFooter ? 'block' : 'none');
		
		if (opts.toolbar) {
			if ($.isArray(opts.toolbar)){
				$('div.datagrid-toolbar', panel).remove();
				var tb = $('<div class="datagrid-toolbar"><table cellspacing="0" cellpadding="0"><tr></tr></table></div>').prependTo(panel);
				var tr = tb.find('tr');
				for(var i=0; i<opts.toolbar.length; i++) {
					var btn = opts.toolbar[i];
					if (btn == '-') {
						$('<td><div class="datagrid-btn-separator"></div></td>').appendTo(tr);
					} else {
						var td = $('<td></td>').appendTo(tr);
						var tool = $('<a href="javascript:void(0)"></a>').appendTo(td);
						tool[0].onclick = eval(btn.handler || function(){});
						tool.linkbutton($.extend({}, btn, {
							plain:true
						}));
					}
				}
			} else {
				$(opts.toolbar).addClass('datagrid-toolbar').prependTo(panel);
				$(opts.toolbar).show();
			}
		} else {
			$('div.datagrid-toolbar', panel).remove();
		}
		
		$('div.datagrid-pager', panel).remove();
		if (opts.pagination) {
			var pager = $('<div class="datagrid-pager"></div>');
			if (opts.pagePosition == 'bottom'){
				pager.appendTo(panel);
			} else if (opts.pagePosition == 'top'){
				pager.addClass('datagrid-pager-top').prependTo(panel);
			} else {
				var ptop = $('<div class="datagrid-pager datagrid-pager-top"></div>').prependTo(panel);
				pager.appendTo(panel);
				pager = pager.add(ptop);
			}
			pager.pagination({
//				total:0,
				total:(opts.pageNumber*opts.pageSize),
				pageNumber:opts.pageNumber,
				pageSize:opts.pageSize,
				pageList:opts.pageList,
				onSelectPage: function(pageNum, pageSize){
					// save the page state
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					
					request(target);	// request new page data
				}
			});
			opts.pageSize = pager.pagination('options').pageSize;	// repare the pageSize value
		}
		
		function createColumnHeader(container, columns, frozen){
			if (!columns) return;
			$(container).show();
			$(container).empty();
			var names = [];
			var orders = [];
			if (opts.sortName){
				names = opts.sortName.split(',');
				orders = opts.sortOrder.split(',');
			}
			var t = $('<table class="datagrid-htable" border="0" cellspacing="0" cellpadding="0"><tbody></tbody></table>').appendTo(container);
			for(var i=0; i<columns.length; i++) {
				var tr = $('<tr class="datagrid-header-row"></tr>').appendTo($('tbody', t));
				var cols = columns[i];
				for(var j=0; j<cols.length; j++){
					var col = cols[j];
					
					var attr = '';
					if (col.rowspan) attr += 'rowspan="' + col.rowspan + '" ';
					if (col.colspan) attr += 'colspan="' + col.colspan + '" ';
					var td = $('<td ' + attr + '></td>').appendTo(tr);
					
					if (col.checkbox){
						td.attr('field', col.field);
						$('<div class="datagrid-header-check"></div>').html('<input type="checkbox"/>').appendTo(td);
					} else if (col.field){
						td.attr('field', col.field);
						td.append('<div class="datagrid-cell"><span></span><span class="datagrid-sort-icon"></span></div>');
						$('span', td).html(col.title);
						$('span.datagrid-sort-icon', td).html('&nbsp;');
						var cell = td.find('div.datagrid-cell');
//						if (opts.sortName == col.field){
//							cell.addClass('datagrid-sort-'+opts.sortOrder);
//						}
//						var pos = names.indexOf(col.field);
						var pos = indexOfArray(names, col.field);
						if (pos >= 0){
							cell.addClass('datagrid-sort-' + orders[pos]);
						}
						if (col.resizable == false){
							cell.attr('resizable', 'false');
						}
						if (col.width){
							cell._outerWidth(col.width);
							col.boxWidth = parseInt(cell[0].style.width);
						} else {
							col.auto = true;
						}
//						cell.css('text-align', (col.align || 'left'));
//						if (col.align){cell.css('text-align', col.align)}
						cell.css('text-align', (col.halign || col.align || ''));
						
						// define the cell class
						col.cellClass = state.cellClassPrefix + '-' + col.field.replace(/[\.|\s]/g,'-');
//						col.cellSelector = '.' + col.cellClass;
						cell.addClass(col.cellClass).css('width', '');
					} else {
						$('<div class="datagrid-cell-group"></div>').html(col.title).appendTo(td);
					}
					
					if (col.hidden){
						td.hide();
					}
				}
				
			}
			if (frozen && opts.rownumbers){
				var td = $('<td rowspan="'+opts.frozenColumns.length+'"><div class="datagrid-header-rownumber"></div></td>');
				if ($('tr',t).length == 0){
					td.wrap('<tr class="datagrid-header-row"></tr>').parent().appendTo($('tbody',t));
				} else {
					td.prependTo($('tr:first', t));
				}
			}
		}
		
		function createColumnStyle(){
			var lines = [];
			var fields = getColumnFields(target,true).concat(getColumnFields(target));
			for(var i=0; i<fields.length; i++){
				var col = getColumnOption(target, fields[i]);
				if (col && !col.checkbox){
					lines.push(['.'+col.cellClass, col.boxWidth ? col.boxWidth + 'px' : 'auto']);
				}
			}
			state.ss.add(lines);
			state.ss.dirty(state.cellSelectorPrefix);	// mark the old selector as dirty that will be removed
			state.cellSelectorPrefix = '.' + state.cellClassPrefix;
		}
	}
	
	/**
	 * bind the datagrid events
	 */
	function bindEvents(target) {
		var state = $.data(target, 'datagrid');
		var panel = state.panel;
		var opts = state.options;
		var dc = state.dc;
		
		var header = dc.header1.add(dc.header2);
		header.find('input[type=checkbox]').unbind('.datagrid').bind('click.datagrid', function(e){
			if (opts.singleSelect && opts.selectOnCheck) return false;
			if ($(this).is(':checked')){
				checkAll(target);
			} else {
				uncheckAll(target);
			}
			e.stopPropagation();
		});
		
		var cells = header.find('div.datagrid-cell');
		cells.closest('td').unbind('.datagrid').bind('mouseenter.datagrid', function(){
			if (state.resizing){return;}
			$(this).addClass('datagrid-header-over');
		}).bind('mouseleave.datagrid', function(){
			$(this).removeClass('datagrid-header-over');
		}).bind('contextmenu.datagrid', function(e){
			var field = $(this).attr('field');
			opts.onHeaderContextMenu.call(target, e, field);
		});
		
		cells.unbind('.datagrid').bind('click.datagrid', function(e){
			var p1 = $(this).offset().left + 5;
			var p2 = $(this).offset().left + $(this)._outerWidth() - 5;
			if (e.pageX < p2 && e.pageX > p1){
				var field = $(this).parent().attr('field');
				var col = getColumnOption(target, field);
				if (!col.sortable || state.resizing) return;
				
//				opts.sortName = field;
//				opts.sortOrder = col.order || 'asc';
//				
//				var cls = 'datagrid-sort-' + opts.sortOrder;
//				if ($(this).hasClass('datagrid-sort-asc')){
//					cls = 'datagrid-sort-desc';
//					opts.sortOrder = 'desc';
//				} else if ($(this).hasClass('datagrid-sort-desc')){
//					cls = 'datagrid-sort-asc';
//					opts.sortOrder = 'asc';
//				}
//				cells.removeClass('datagrid-sort-asc datagrid-sort-desc');
//				$(this).addClass(cls);
				
				var names = [];
				var orders = [];
				if (opts.sortName){
					names = opts.sortName.split(',');
					orders = opts.sortOrder.split(',');
				}
//				var pos = names.indexOf(field);
				var pos = indexOfArray(names, field);
				var originalOrder = col.order || 'asc';
				if (pos >= 0){
					$(this).removeClass('datagrid-sort-asc datagrid-sort-desc');
					var nextOrder = orders[pos] == 'asc' ? 'desc' : 'asc';
					if (opts.multiSort && nextOrder == originalOrder){
						names.splice(pos,1);
						orders.splice(pos,1);
					} else {
						orders[pos] = nextOrder;
						$(this).addClass('datagrid-sort-' + nextOrder);
					}
				} else {
					if (opts.multiSort){
						names.push(field);
						orders.push(originalOrder);
					} else {
						names = [field];
						orders = [originalOrder];
						cells.removeClass('datagrid-sort-asc datagrid-sort-desc');
					}
					$(this).addClass('datagrid-sort-' + originalOrder);
				}
				opts.sortName = names.join(',');
				opts.sortOrder = orders.join(',');
				
				if (opts.remoteSort){
					request(target);
				} else {
					var data = $.data(target, 'datagrid').data;
					loadData(target, data);
				}
				
				opts.onSortColumn.call(target, opts.sortName, opts.sortOrder);
			}
		}).bind('dblclick.datagrid', function(e){
			var p1 = $(this).offset().left + 5;
			var p2 = $(this).offset().left + $(this)._outerWidth() - 5;
			var cond = opts.resizeHandle == 'right' ? (e.pageX > p2) : (opts.resizeHandle == 'left' ? (e.pageX < p1) : (e.pageX < p1 || e.pageX > p2));
			if (cond){
				var field = $(this).parent().attr('field');
				var col = getColumnOption(target, field);
				if (col.resizable == false) return;
				$(target).datagrid('autoSizeColumn', field);
				col.auto = false;
			}
		});
		
		var resizeHandle = opts.resizeHandle == 'right' ? 'e' : (opts.resizeHandle == 'left' ? 'w' : 'e,w');
		cells.each(function(){
			$(this).resizable({
//				handles:'e',
				handles:resizeHandle,
				disabled:($(this).attr('resizable') ? $(this).attr('resizable')=='false' : false),
				minWidth:25,
				onStartResize: function(e){
					state.resizing = true;
//					header.css('cursor', 'e-resize');
					header.css('cursor', $('body').css('cursor'));
					if (!state.proxy){
						state.proxy = $('<div class="datagrid-resize-proxy"></div>').appendTo(dc.view);
					}
					state.proxy.css({
						left:e.pageX - $(panel).offset().left - 1,
						display:'none'
					});
					setTimeout(function(){
						if (state.proxy) state.proxy.show();
					}, 500);
				},
				onResize: function(e){
					state.proxy.css({
						left:e.pageX - $(panel).offset().left - 1,
						display:'block'
					});
					return false;
				},
				onStopResize: function(e){
					header.css('cursor', '');
					$(this).css('height','');
					$(this)._outerWidth($(this)._outerWidth());
					var field = $(this).parent().attr('field');
					var col = getColumnOption(target, field);
					col.width = $(this)._outerWidth();
					col.boxWidth = parseInt(this.style.width);
					col.auto = undefined;
					$(this).css('width', '');
					fixColumnSize(target, field);
//					dc.view2.children('div.datagrid-header').scrollLeft(dc.body2.scrollLeft());
					state.proxy.remove();
					state.proxy = null;
					if ($(this).parents('div:first.datagrid-header').parent().hasClass('datagrid-view1')){
						setBodySize(target);
					}
					fitColumns(target);
					opts.onResizeColumn.call(target, field, col.width);
					setTimeout(function(){
						state.resizing = false;
					}, 0);
				}
			});
		});
		
		dc.body1.add(dc.body2).unbind().bind('mouseover', function(e){
			if (state.resizing){return;}
			var tr = $(e.target).closest('tr.datagrid-row');
			if (!doesExist(tr)){return;}
			var index = getIndex(tr);
			highlightRow(target, index);
			e.stopPropagation();
		}).bind('mouseout', function(e){
			var tr = $(e.target).closest('tr.datagrid-row');
			if (!doesExist(tr)){return;}
			var index = getIndex(tr);
			opts.finder.getTr(target, index).removeClass('datagrid-row-over');
			e.stopPropagation();
		}).bind('click', function(e){
			var tt = $(e.target);
			var tr = tt.closest('tr.datagrid-row');
			if (!doesExist(tr)){return;}
			var index = getIndex(tr);
			if (tt.parent().hasClass('datagrid-cell-check')){	// click the checkbox
				if (opts.singleSelect && opts.selectOnCheck){
					if (!opts.checkOnSelect) {
						uncheckAll(target, true);
					}
					checkRow(target, index);
				} else {
					if (tt.is(':checked')){
						checkRow(target, index);
					} else {
						uncheckRow(target, index);
					}
				}
			} else {
				var row = opts.finder.getRow(target, index);
				var td = tt.closest('td[field]',tr);
				if (td.length){
					var field = td.attr('field');
					opts.onClickCell.call(target, index, field, row[field]);
				}
				
				if (opts.singleSelect == true){
					selectRow(target, index);
				} else {
					if (tr.hasClass('datagrid-row-selected')){
						unselectRow(target, index);
					} else {
						selectRow(target, index);
					}
				}
				opts.onClickRow.call(target, index, row);
			}
			e.stopPropagation();
		}).bind('dblclick', function(e){
			var tt = $(e.target);
			var tr = tt.closest('tr.datagrid-row');
			if (!doesExist(tr)){return;}
			var index = getIndex(tr);
			var row = opts.finder.getRow(target, index);
			var td = tt.closest('td[field]',tr);
			if (td.length){
				var field = td.attr('field');
				opts.onDblClickCell.call(target, index, field, row[field]);
			}
			opts.onDblClickRow.call(target, index, row);
			e.stopPropagation();
		}).bind('contextmenu', function(e){
			var tr = $(e.target).closest('tr.datagrid-row');
			if (!doesExist(tr)){return;}
			var index = getIndex(tr);
			var row = opts.finder.getRow(target, index);
			opts.onRowContextMenu.call(target, e, index, row);
			e.stopPropagation();
		});
		dc.body2.bind('scroll', function(){
			var b1 = dc.view1.children('div.datagrid-body');
			b1.scrollTop($(this).scrollTop());
			var c1 = dc.body1.children(':first');
			var c2 = dc.body2.children(':first');
			if (c1.length && c2.length){
				var top1 = c1.offset().top;
				var top2 = c2.offset().top;
				if (top1 != top2){
					b1.scrollTop(b1.scrollTop()+top1-top2);
				}
			}
			
//			dc.view1.children('div.datagrid-body').scrollTop($(this).scrollTop());
			dc.view2.children('div.datagrid-header,div.datagrid-footer')._scrollLeft($(this)._scrollLeft());
			dc.body2.children('table.datagrid-btable-frozen').css('left', -$(this)._scrollLeft());
		});
		
		function getIndex(tr){
			if (tr.attr('datagrid-row-index')){
				return parseInt(tr.attr('datagrid-row-index'));
			} else {
				return tr.attr('node-id');
			}
		}
		function doesExist(tr){
			return tr.length && tr.parent().length;
		}
	}
	
	/**
	 * expand the columns to fit the grid width
	 */
	function fitColumns(target){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		dc.body2.css('overflow-x', opts.fitColumns?'hidden':'');
		if (!opts.fitColumns){return;}
		if (!state.leftWidth){state.leftWidth = 0;}
		
		var header = dc.view2.children('div.datagrid-header');
		var fieldWidths = 0;
		var lastColumn;
		var fields = getColumnFields(target, false);
		for(var i=0; i<fields.length; i++){
			var col = getColumnOption(target, fields[i]);
			if (canResize(col)){
				fieldWidths += col.width;
				lastColumn = col;
			}
		}
		if (!fieldWidths){return}
		if (lastColumn){
			addHeaderWidth(lastColumn, -state.leftWidth);
		}
		var headerInner = header.children('div.datagrid-header-inner').show();
		var leftWidth = header.width() - header.find('table').width() - opts.scrollbarSize + state.leftWidth;
		var rate = leftWidth / fieldWidths;
		if (!opts.showHeader){headerInner.hide();}
		for(var i=0; i<fields.length; i++){
			var col = getColumnOption(target, fields[i]);
			if (canResize(col)){
				var width = parseInt(col.width * rate);
				addHeaderWidth(col, width);
				leftWidth -= width;
			}
		}
		
		state.leftWidth = leftWidth;
		if (lastColumn){
			addHeaderWidth(lastColumn, state.leftWidth);
		}
		fixColumnSize(target);
		
		function addHeaderWidth(col, width){
			col.width += width;
			col.boxWidth += width;
		}
		function canResize(col){
			if (!col.hidden && !col.checkbox && !col.auto && !col.fixed) return true;
		}
	}
	
	/**
	 * adjusts the column width to fit the contents.
	 */
	function autoSizeColumn(target, field){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		var tmp = $('<div class="datagrid-cell" style="position:absolute;left:-9999px"></div>').appendTo('body');
		if (field){
			setSize(field);
			if (opts.fitColumns){
				setBodySize(target);
				fitColumns(target);
			}
		} else {
			var canFitColumns = false;
			var fields = getColumnFields(target,true).concat(getColumnFields(target,false));
			for(var i=0; i<fields.length; i++){
				var field = fields[i];
				var col = getColumnOption(target, field);
				if (col.auto){
					setSize(field);
					canFitColumns = true;
				}
			}
			if (canFitColumns && opts.fitColumns){
				setBodySize(target);
				fitColumns(target);
			}
		}
		tmp.remove();
		
		function setSize(field){
			var headerCell = dc.view.find('div.datagrid-header td[field="' + field + '"] div.datagrid-cell');
			headerCell.css('width', '');
			var col = $(target).datagrid('getColumnOption', field);
			col.width = undefined;
			col.boxWidth = undefined;
			col.auto = true;
			$(target).datagrid('fixColumnSize', field);
			var width = Math.max(getWidth('header'), getWidth('allbody'), getWidth('allfooter'));
			headerCell._outerWidth(width);
			col.width = width;
			col.boxWidth = parseInt(headerCell[0].style.width);
			headerCell.css('width', '');
			$(target).datagrid('fixColumnSize', field);
			opts.onResizeColumn.call(target, field, col.width);
			
			// get cell width of specified type(body or footer)
			function getWidth(type){
				var width = 0;
				if (type == 'header'){
					width = getCellWidth(headerCell);
				} else {
					opts.finder.getTr(target,0,type).find('td[field="' + field + '"] div.datagrid-cell').each(function(){
						var w = getCellWidth($(this));
						if (width < w){
							width = w;
						}
					});
				}
				return width;
				
				function getCellWidth(cell){
					return cell.is(':visible') ? cell._outerWidth() : tmp.html(cell.html())._outerWidth();
				}
			}
		}
	}
	
	
	/**
	 * fix column size for the specified field
	 */
	function fixColumnSize(target, field){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		var table = dc.view.find('table.datagrid-btable,table.datagrid-ftable');
		table.css('table-layout','fixed');
		if (field) {
			fix(field);
		} else {
			var ff = getColumnFields(target, true).concat(getColumnFields(target, false));	// get all fields
			for(var i=0; i<ff.length; i++){
				fix(ff[i]);
			}
		}
		table.css('table-layout','auto');
		fixMergedSize(target);
		
		setTimeout(function(){
			fixRowHeight(target);
			fixEditableSize(target);
		}, 0);
		
		function fix(field){
			var col = getColumnOption(target, field);
			if (!col.checkbox){
				state.ss.set('.'+col.cellClass, col.boxWidth ? col.boxWidth + 'px' : 'auto');
			}
		}
	}
	
//	function fixMergedSize(target){
//		var dc = $.data(target, 'datagrid').dc;
//		var cells = dc.body1.add(dc.body2).find('td.datagrid-td-merged>div.datagrid-cell');
//		cells.css('width','').each(function(){
//			$(this)._outerWidth($(this).parent().width());
//		});
//	}
	function fixMergedSize(target){
		var dc = $.data(target, 'datagrid').dc;
		dc.body1.add(dc.body2).find('td.datagrid-td-merged').each(function(){
			var td = $(this);
			var colspan = td.attr('colspan') || 1;
			var width = getColumnOption(target, td.attr('field')).width;
			for(var i=1; i<colspan; i++){
				td = td.next();
				width += getColumnOption(target, td.attr('field')).width+1;
			}
			$(this).children('div.datagrid-cell')._outerWidth(width);
		});
	}
	
	function fixEditableSize(target){
		var dc = $.data(target, 'datagrid').dc;
		dc.view.find('div.datagrid-editable').each(function(){
			var cell = $(this);
			var field = cell.parent().attr('field');
			var col = $(target).datagrid('getColumnOption', field);
			cell._outerWidth(col.width);
			var ed = $.data(this, 'datagrid.editor');
			if (ed.actions.resize) {
				ed.actions.resize(ed.target, cell.width());
			}
		});
	}
	
	function getColumnOption(target, field){
		function find(columns){
			if (columns) {
				for(var i=0; i<columns.length; i++){
					var cc = columns[i];
					for(var j=0; j<cc.length; j++){
						var c = cc[j];
						if (c.field == field){
							return c;
						}
					}
				}
			}
			return null;
		}
		
		var opts = $.data(target, 'datagrid').options;
		var col = find(opts.columns);
		if (!col){
			col = find(opts.frozenColumns);
		}
		return col;
	}
	
	/**
	 * get column fields which will be show in row
	 */
	function getColumnFields(target, frozen){
		var opts = $.data(target, 'datagrid').options;
		var columns = (frozen==true) ? (opts.frozenColumns || [[]]) : opts.columns;
		if (columns.length == 0) return [];
		
		var fields = [];
		
		function getColumnIndex(count){
			var c = 0;
			var i = 0;
			while(true){
				if (fields[i] == undefined){
					if (c == count){
						return i;
					}
					c ++;
				}
				i++;
			}
		}
		
		function getFields(r){
			var ff = [];
			var c = 0;
			for(var i=0; i<columns[r].length; i++){
				var col = columns[r][i];
				if (col.field){
					ff.push([c, col.field]);	// store the field index and name
				}
				c += parseInt(col.colspan || '1');
			}
			for(var i=0; i<ff.length; i++){
				ff[i][0] = getColumnIndex(ff[i][0]);	// calculate the real index in fields array
			}
			for(var i=0; i<ff.length; i++){
				var f = ff[i];
				fields[f[0]] = f[1];	// update the field name
			}
		}
		
		for(var i=0; i<columns.length; i++){
			getFields(i);
		}
		
		return fields;
	}
	
	/**
	 * load data to the grid
	 */
	function loadData(target, data){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var dc = state.dc;
		data = opts.loadFilter.call(target, data);
		data.total = parseInt(data.total);
		state.data = data;
		if (data.footer){
			state.footer = data.footer;
		}
		
		if (!opts.remoteSort && opts.sortName){
			var names = opts.sortName.split(',');
			var orders = opts.sortOrder.split(',');
			data.rows.sort(function(r1,r2){
				var r = 0;
				for(var i=0; i<names.length; i++){
					var sn = names[i];
					var so = orders[i];
					var col = getColumnOption(target, sn);
					var sortFunc = col.sorter || function(a,b){
						return a==b ? 0 : (a>b?1:-1);
					};
					r = sortFunc(r1[sn], r2[sn]) * (so=='asc'?1:-1);
					if (r != 0){
						return r;
					}
				}
				return r;
			});
			
//			var opt = getColumnOption(target, opts.sortName);
//			if (opt){
//				var sortFunc = opt.sorter || function(a,b){
//					return (a>b?1:-1);
//				};
//				data.rows.sort(function(r1,r2){
//					return sortFunc(r1[opts.sortName], r2[opts.sortName])*(opts.sortOrder=='asc'?1:-1);
//				});
//			}
		}
		
		// render datagrid view
		if (opts.view.onBeforeRender){
			opts.view.onBeforeRender.call(opts.view, target, data.rows);
		}
		opts.view.render.call(opts.view, target, dc.body2, false);
		opts.view.render.call(opts.view, target, dc.body1, true);
		if (opts.showFooter){
			opts.view.renderFooter.call(opts.view, target, dc.footer2, false);
			opts.view.renderFooter.call(opts.view, target, dc.footer1, true);
		}
		if (opts.view.onAfterRender){
			opts.view.onAfterRender.call(opts.view, target);
		}
		
		state.ss.clean();
		
		opts.onLoadSuccess.call(target, data);
		
		var pager = $(target).datagrid('getPager');
		if (pager.length){
			var popts = pager.pagination('options');
			if (popts.total != data.total){
				pager.pagination('refresh',{total:data.total});
				if (opts.pageNumber != popts.pageNumber){
					opts.pageNumber = popts.pageNumber;
					request(target);
				}
			}
//			if (pager.pagination('options').total != data.total){
//				pager.pagination('refresh',{total:data.total});
//			}
		}
		
		fixRowHeight(target);
//		bindRowEvents(target);
		dc.body2.triggerHandler('scroll');
		
		setSelection();
		$(target).datagrid('autoSizeColumn');
		
		/*
		 * set row selection that previously selected
		 */
		function setSelection(){
			if (opts.idField){
				for(var i=0; i<data.rows.length; i++){
					var row = data.rows[i];
					if (contains(state.selectedRows, row)){
						opts.finder.getTr(target, i).addClass('datagrid-row-selected');
					}
					if (contains(state.checkedRows, row)){
						opts.finder.getTr(target, i).find('div.datagrid-cell-check input[type=checkbox]')._propAttr('checked', true);
					}
				}
			}
			function contains(a,r){
				for(var i=0; i<a.length; i++){
					if (a[i][opts.idField] == r[opts.idField]){
						a[i] = r;
						return true;
					}
				}
				return false;
			}
		}
	}
	
	/**
	 * Return the index of specified row or -1 if not found.
	 * row: id value or row record
	 */
	function getRowIndex(target, row){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var rows = state.data.rows;
		if (typeof row == 'object'){
			return indexOfArray(rows, row);
		} else {
			for(var i=0; i<rows.length; i++){
				if (rows[i][opts.idField] == row){
					return i;
				}
			}
			return -1;
		}
	}
	
	function getSelectedRows(target){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var data = state.data;
		
		if (opts.idField){
			return state.selectedRows;
		} else {
			var rows = [];
			opts.finder.getTr(target, '', 'selected', 2).each(function(){
				var index = parseInt($(this).attr('datagrid-row-index'));
				rows.push(data.rows[index]);
			});
			return rows;
		}
	}
	
	function getCheckedRows(target){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		if (opts.idField){
			return state.checkedRows;
		} else {
			var rows = [];
			opts.finder.getTr(target, '', 'checked', 2).each(function(){
				rows.push(opts.finder.getRow(target, $(this)));
			});
			return rows;
		}
	}
	
	function scrollTo(target, index){
		var state = $.data(target, 'datagrid');
		var dc = state.dc;
		var opts = state.options;
		var tr = opts.finder.getTr(target, index);
		if (tr.length){
			if (tr.closest('table').hasClass('datagrid-btable-frozen')){return;}
			var headerHeight = dc.view2.children('div.datagrid-header')._outerHeight();
			var body2 = dc.body2;
			var frozenHeight = body2.outerHeight(true) - body2.outerHeight();
			var top = tr.position().top - headerHeight - frozenHeight;
			if (top < 0){
				body2.scrollTop(body2.scrollTop() + top);
			} else if (top + tr._outerHeight() > body2.height() - 18){
				body2.scrollTop(body2.scrollTop() + top + tr._outerHeight() - body2.height() + 18);
			}
		}
	}
	
	function highlightRow(target, index){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		opts.finder.getTr(target, state.highlightIndex).removeClass('datagrid-row-over');
		opts.finder.getTr(target, index).addClass('datagrid-row-over');
		state.highlightIndex = index;
//		scrollTo(target, index);
	}
	
	/**
	 * select a row, the row index start with 0
	 */
	function selectRow(target, index, notCheck){
		var state = $.data(target, 'datagrid');
		var dc = state.dc;
		var opts = state.options;
		var selectedRows = state.selectedRows;
		
		if (opts.singleSelect){
			unselectAll(target);
			selectedRows.splice(0, selectedRows.length);
		}
		if (!notCheck && opts.checkOnSelect){
			checkRow(target, index, true);	// don't select the row again
		}
		
		var row = opts.finder.getRow(target, index);
		if (opts.idField){
			addArrayItem(selectedRows, opts.idField, row);
		}
		opts.finder.getTr(target, index).addClass('datagrid-row-selected');
		opts.onSelect.call(target, index, row);
		scrollTo(target, index);
	}
	/**
	 * unselect a row
	 */
	function unselectRow(target, index, notCheck){
		var state = $.data(target, 'datagrid');
		var dc = state.dc;
		var opts = state.options;
		var selectedRows = $.data(target, 'datagrid').selectedRows;
		
		if (!notCheck && opts.checkOnSelect){
			uncheckRow(target, index, true);	// don't unselect the row again
		}
		opts.finder.getTr(target, index).removeClass('datagrid-row-selected');
		var row = opts.finder.getRow(target, index);
		if (opts.idField){
			removeArrayItem(selectedRows, opts.idField, row[opts.idField]);
		}
		opts.onUnselect.call(target, index, row);
	}
	/**
	 * select all rows on current page
	 */
	function selectAll(target, notCheck){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var rows = state.data.rows;
		var selectedRows = $.data(target, 'datagrid').selectedRows;
		
		if (!notCheck && opts.checkOnSelect){
			checkAll(target, true);	// don't select rows again
		}
		opts.finder.getTr(target, '', 'allbody').addClass('datagrid-row-selected');
		if (opts.idField){
			for(var index=0; index<rows.length; index++){
				addArrayItem(selectedRows, opts.idField, rows[index]);
			}
		}
		opts.onSelectAll.call(target, rows);
	}
	/**
	 * unselect all rows on current page
	 */
	function unselectAll(target, notCheck){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var rows = state.data.rows;
		var selectedRows = $.data(target, 'datagrid').selectedRows;
		
		if (!notCheck && opts.checkOnSelect){
			uncheckAll(target, true);	// don't unselect rows again
		}
		opts.finder.getTr(target, '', 'selected').removeClass('datagrid-row-selected');
		if (opts.idField){
			for(var index=0; index<rows.length; index++){
				removeArrayItem(selectedRows, opts.idField, rows[index][opts.idField]);
			}
		}
		opts.onUnselectAll.call(target, rows);
	}
	
	/**
	 * check a row, the row index start with 0
	 */
	function checkRow(target, index, notSelect){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		if (!notSelect && opts.selectOnCheck){
			selectRow(target, index, true);	// don't check the row again
		}
		var tr = opts.finder.getTr(target, index).addClass('datagrid-row-checked');
		var ck = tr.find('div.datagrid-cell-check input[type=checkbox]');
		ck._propAttr('checked', true);
		tr = opts.finder.getTr(target, '', 'checked', 2);
		if (tr.length == state.data.rows.length){
			var dc = state.dc;
			var header = dc.header1.add(dc.header2);
			header.find('input[type=checkbox]')._propAttr('checked', true);
		}
		var row = opts.finder.getRow(target, index);
		if (opts.idField){
			addArrayItem(state.checkedRows, opts.idField, row);
		}
		opts.onCheck.call(target, index, row);
	}
	/**
	 * uncheck a row
	 */
	function uncheckRow(target, index, notSelect){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		if (!notSelect && opts.selectOnCheck){
			unselectRow(target, index, true);	// don't uncheck the row again
		}
		var tr = opts.finder.getTr(target, index).removeClass('datagrid-row-checked');
		var ck = tr.find('div.datagrid-cell-check input[type=checkbox]');
		ck._propAttr('checked', false);
		var dc = state.dc;
		var header = dc.header1.add(dc.header2);
		header.find('input[type=checkbox]')._propAttr('checked', false);
		var row = opts.finder.getRow(target, index);
		if (opts.idField){
			removeArrayItem(state.checkedRows, opts.idField, row[opts.idField]);
		}
		opts.onUncheck.call(target, index, row);
	}
	/**
	 * check all checkbox on current page
	 */
	function checkAll(target, notSelect){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var rows = state.data.rows;
		if (!notSelect && opts.selectOnCheck){
			selectAll(target, true);	// don't check rows again
		}
		var dc = state.dc;
		var hck = dc.header1.add(dc.header2).find('input[type=checkbox]');
		var bck = opts.finder.getTr(target, '', 'allbody').addClass('datagrid-row-checked').find('div.datagrid-cell-check input[type=checkbox]');
		hck.add(bck)._propAttr('checked', true);
		if (opts.idField){
			for(var i=0; i<rows.length; i++){
				addArrayItem(state.checkedRows, opts.idField, rows[i]);
			}
		}
		opts.onCheckAll.call(target, rows);
	}
	/**
	 * uncheck all checkbox on current page
	 */
	function uncheckAll(target, notSelect){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var rows = state.data.rows;
		if (!notSelect && opts.selectOnCheck){
			unselectAll(target, true);	// don't uncheck rows again
		}
		var dc = state.dc;
		var hck = dc.header1.add(dc.header2).find('input[type=checkbox]');
		var bck = opts.finder.getTr(target, '', 'checked').removeClass('datagrid-row-checked').find('div.datagrid-cell-check input[type=checkbox]');
//		var bck = opts.finder.getTr(target, '', 'allbody').find('div.datagrid-cell-check input[type=checkbox]');
		hck.add(bck)._propAttr('checked', false);
		if (opts.idField){
			for(var i=0; i<rows.length; i++){
				removeArrayItem(state.checkedRows, opts.idField, rows[i][opts.idField]);
			}
		}
		opts.onUncheckAll.call(target, rows);
	}
	
	
	/**
	 * Begin edit a row
	 */
	function beginEdit(target, index){
		var opts = $.data(target, 'datagrid').options;
		var tr = opts.finder.getTr(target, index);
		var row = opts.finder.getRow(target, index);
		if (tr.hasClass('datagrid-row-editing')) return;
		if (opts.onBeforeEdit.call(target, index, row) == false) return;
		
		tr.addClass('datagrid-row-editing');
		createEditor(target, index);
		fixEditableSize(target);
		
		tr.find('div.datagrid-editable').each(function(){
			var field = $(this).parent().attr('field');
			var ed = $.data(this, 'datagrid.editor');
			ed.actions.setValue(ed.target, row[field]);
		});
		validateRow(target, index);	// validate the row data
	}
	
	/**
	 * Stop edit a row.
	 * index: the row index.
	 * cancel: if true, restore the row data.
	 */
	function endEdit(target, index, cancel){
		var opts = $.data(target, 'datagrid').options;
		var updatedRows = $.data(target, 'datagrid').updatedRows;
		var insertedRows = $.data(target, 'datagrid').insertedRows;
		
		var tr = opts.finder.getTr(target, index);
		var row = opts.finder.getRow(target, index);
		if (!tr.hasClass('datagrid-row-editing')) {
			return;
		}
		
		if (!cancel){
			if (!validateRow(target, index)) return;	// invalid row data
			
			var changed = false;
			var changes = {};
			tr.find('div.datagrid-editable').each(function(){
				var field = $(this).parent().attr('field');
				var ed = $.data(this, 'datagrid.editor');
				var value = ed.actions.getValue(ed.target);
				if (row[field] != value){
					row[field] = value;
					changed = true;
					changes[field] = value;
				}
			});
			if (changed){
				if (indexOfArray(insertedRows, row) == -1){
					if (indexOfArray(updatedRows, row) == -1){
						updatedRows.push(row);
					}
				}
			}
		}
		
		tr.removeClass('datagrid-row-editing');
		
		destroyEditor(target, index);
		$(target).datagrid('refreshRow', index);
		
		if (!cancel){
			opts.onAfterEdit.call(target, index, row, changes);
		} else {
			opts.onCancelEdit.call(target, index, row);
		}
	}
	
	/**
	 * get the specified row editors
	 */
	function getEditors(target, index){
		var opts = $.data(target, 'datagrid').options;
		var tr = opts.finder.getTr(target, index);
		var editors = [];
		tr.children('td').each(function(){
			var cell = $(this).find('div.datagrid-editable');
			if (cell.length){
				var ed = $.data(cell[0], 'datagrid.editor');
				editors.push(ed);
			}
		});
		return editors;
	}
	
	/**
	 * get the cell editor
	 * param contains two parameters: index and field
	 */
	function getEditor(target, param){
		var editors = getEditors(target, param.index!=undefined ? param.index : param.id);
		for(var i=0; i<editors.length; i++){
			if (editors[i].field == param.field){
				return editors[i];
			}
		}
		return null;
	}
	
	/**
	 * create the row editor and adjust the row height.
	 */
	function createEditor(target, index){
		var opts = $.data(target, 'datagrid').options;
		var tr = opts.finder.getTr(target, index);
		tr.children('td').each(function(){
			var cell = $(this).find('div.datagrid-cell');
			var field = $(this).attr('field');
			
			var col = getColumnOption(target, field);
			if (col && col.editor){
				// get edit type and options
				var edittype,editoptions;
				if (typeof col.editor == 'string'){
					edittype = col.editor;
				} else {
					edittype = col.editor.type;
					editoptions = col.editor.options;
				}
				
				// get the specified editor
				var editor = opts.editors[edittype];
				if (editor){
					var oldHtml = cell.html();
					var width = cell._outerWidth();
					cell.addClass('datagrid-editable');
					cell._outerWidth(width);
					cell.html('<table border="0" cellspacing="0" cellpadding="1"><tr><td></td></tr></table>');
//					cell.children('table').attr('align', col.align);
					cell.children('table').bind('click dblclick contextmenu',function(e){
						e.stopPropagation();
					});
					$.data(cell[0], 'datagrid.editor', {
						actions: editor,
						target: editor.init(cell.find('td'), editoptions),
						field: field,
						type: edittype,
						oldHtml: oldHtml
					});
				}
			}
		});
		fixRowHeight(target, index, true);
	}
	
	/**
	 * destroy the row editor and restore the row height.
	 */
	function destroyEditor(target, index){
		var opts = $.data(target, 'datagrid').options;
		var tr = opts.finder.getTr(target, index);
		tr.children('td').each(function(){
			var cell = $(this).find('div.datagrid-editable');
			if (cell.length){
				var ed = $.data(cell[0], 'datagrid.editor');
				if (ed.actions.destroy) {
					ed.actions.destroy(ed.target);
				}
				cell.html(ed.oldHtml);
				$.removeData(cell[0], 'datagrid.editor');
				
				cell.removeClass('datagrid-editable');
				cell.css('width','');
			}
		});
	}
	
	/**
	 * Validate while editing, if valid return true.
	 */
	function validateRow(target, index){
		var tr = $.data(target, 'datagrid').options.finder.getTr(target, index);
		if (!tr.hasClass('datagrid-row-editing')){
			return true;
		}
		
		var vbox = tr.find('.validatebox-text');
		vbox.validatebox('validate');
		vbox.trigger('mouseleave');
		var invalidbox = tr.find('.validatebox-invalid');
		return invalidbox.length == 0;
	}
	
	/**
	 * Get changed rows, if state parameter is not assigned, return all changed.
	 * state: inserted,deleted,updated
	 */
	function getChanges(target, state){
		var insertedRows = $.data(target, 'datagrid').insertedRows;
		var deletedRows = $.data(target, 'datagrid').deletedRows;
		var updatedRows = $.data(target, 'datagrid').updatedRows;
		
		if (!state){
			var rows = [];
			rows = rows.concat(insertedRows);
			rows = rows.concat(deletedRows);
			rows = rows.concat(updatedRows);
			return rows;
		} else if (state == 'inserted'){
			return insertedRows;
		} else if (state == 'deleted'){
			return deletedRows;
		} else if (state == 'updated'){
			return updatedRows;
		}
		
		return [];
	}
	
	function deleteRow(target, index){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var data = state.data;
		var insertedRows = state.insertedRows;
		var deletedRows = state.deletedRows;
		
		$(target).datagrid('cancelEdit', index);
		
		var row = data.rows[index];
		if (indexOfArray(insertedRows, row) >= 0){
			removeArrayItem(insertedRows, row);
		} else {
			deletedRows.push(row);
		}
		removeArrayItem(state.selectedRows, opts.idField, data.rows[index][opts.idField]);
		removeArrayItem(state.checkedRows, opts.idField, data.rows[index][opts.idField]);
		
		opts.view.deleteRow.call(opts.view, target, index);
		if (opts.height == 'auto'){
			fixRowHeight(target);	// adjust the row height
		}
		$(target).datagrid('getPager').pagination('refresh', {total:data.total});
	}
	
	function insertRow(target, param){
		var data = $.data(target, 'datagrid').data;
		var view = $.data(target, 'datagrid').options.view;
		var insertedRows = $.data(target, 'datagrid').insertedRows;
		view.insertRow.call(view, target, param.index, param.row);
//		bindRowEvents(target);
		insertedRows.push(param.row);
		$(target).datagrid('getPager').pagination('refresh', {total:data.total});
	}
	
	function appendRow(target, row){
		var data = $.data(target, 'datagrid').data;
		var view = $.data(target, 'datagrid').options.view;
		var insertedRows = $.data(target, 'datagrid').insertedRows;
		view.insertRow.call(view, target, null, row);
		insertedRows.push(row);
		$(target).datagrid('getPager').pagination('refresh', {total:data.total});
	}
	
	function initChanges(target){
		var state = $.data(target, 'datagrid');
		var data = state.data;
		var rows = data.rows;
		var originalRows = [];
		for(var i=0; i<rows.length; i++){
			originalRows.push($.extend({}, rows[i]));
		}
		state.originalRows = originalRows;
		state.updatedRows = [];
		state.insertedRows = [];
		state.deletedRows = [];
	}
	
	function acceptChanges(target){
		var data = $.data(target, 'datagrid').data;
		var ok = true;
		for(var i=0,len=data.rows.length; i<len; i++){
			if (validateRow(target, i)){
				endEdit(target, i, false);
			} else {
				ok = false;
			}
		}
		if (ok){
			initChanges(target);
		}
	}
	
	function rejectChanges(target){
		var state = $.data(target, 'datagrid');
		var opts = state.options;
		var originalRows = state.originalRows;
		var insertedRows = state.insertedRows;
		var deletedRows = state.deletedRows;
		var selectedRows = state.selectedRows;
		var checkedRows = state.checkedRows;
		var data = state.data;
		
		function getIds(a){
			var ids = [];
			for(var i=0; i<a.length; i++){
				ids.push(a[i][opts.idField]);
			}
			return ids;
		}
		function doSelect(ids, action){
			for(var i=0; i<ids.length; i++){
				var index = getRowIndex(target, ids[i]);
				if (index >= 0){
					(action=='s'?selectRow:checkRow)(target, index, true);
				}
			}
		}
		
		for(var i=0; i<data.rows.length; i++){endEdit(target, i, true);}
		
		var selectedIds = getIds(selectedRows);
		var checkedIds = getIds(checkedRows);
		selectedRows.splice(0, selectedRows.length);
		checkedRows.splice(0, checkedRows.length);
		
		data.total += deletedRows.length - insertedRows.length;
		data.rows = originalRows;
		loadData(target, data);
		
		doSelect(selectedIds, 's');
		doSelect(checkedIds, 'c');
		
		initChanges(target);
	}
	
	/**
	 * request remote data
	 */
	function request(target, params){
		var opts = $.data(target, 'datagrid').options;
		
		if (params) opts.queryParams = params;
		
		var param = $.extend({}, opts.queryParams);
		if (opts.pagination){
			$.extend(param, {
				page: opts.pageNumber,
				rows: opts.pageSize
			});
		}
		if (opts.sortName){
			$.extend(param, {
				sort: opts.sortName,
				order: opts.sortOrder
			});
		}
		
		if (opts.onBeforeLoad.call(target, param) == false) return;
		
		$(target).datagrid('loading');
		setTimeout(function(){
			doRequest();
		}, 0);
		
		function doRequest(){
			var result = opts.loader.call(target, param, function(data){
				setTimeout(function(){
					$(target).datagrid('loaded');
				}, 0);
				loadData(target, data);
				setTimeout(function(){
					initChanges(target);
				}, 0);
			}, function(){
				setTimeout(function(){
					$(target).datagrid('loaded');
				}, 0);
				opts.onLoadError.apply(target, arguments);
			});
			if (result == false){
				$(target).datagrid('loaded');
			}
		}
	}
	
	function mergeCells(target, param){
		var opts = $.data(target, 'datagrid').options;
		
		param.rowspan = param.rowspan || 1;
		param.colspan = param.colspan || 1;
		
		if (param.rowspan == 1 && param.colspan == 1) return;
		
		var tr = opts.finder.getTr(target, (param.index!=undefined ? param.index : param.id));
		if (!tr.length){return;}
		var row = opts.finder.getRow(target, tr);
		var value = row[param.field];	// the cell value
		
		var td = tr.find('td[field="'+param.field+'"]');
		td.attr('rowspan', param.rowspan).attr('colspan', param.colspan);
		td.addClass('datagrid-td-merged');
		
		for(var i=1; i<param.colspan; i++){
			td = td.next();
			td.hide();
			row[td.attr('field')] = value;
		}
		for(var i=1; i<param.rowspan; i++){
			tr = tr.next();
			if (!tr.length){break;}
			var row = opts.finder.getRow(target, tr);
			var td = tr.find('td[field="'+param.field+'"]').hide();
			row[td.attr('field')] = value;
			for(var j=1; j<param.colspan; j++){
				td = td.next();
				td.hide();
				row[td.attr('field')] = value;
			}
		}
		
		fixMergedSize(target);
	}
	
	$.fn.datagrid = function(options, param){
		if (typeof options == 'string'){
			return $.fn.datagrid.methods[options](this, param);
		}
		
		options = options || {};
		return this.each(function(){
			var state = $.data(this, 'datagrid');
			var opts;
			if (state) {
				opts = $.extend(state.options, options);
				state.options = opts;
			} else {
				opts = $.extend({}, $.extend({},$.fn.datagrid.defaults,{queryParams:{}}), $.fn.datagrid.parseOptions(this), options);
				$(this).css('width', '').css('height', '');
				
				var wrapResult = wrapGrid(this, opts.rownumbers);
				if (!opts.columns) opts.columns = wrapResult.columns;
				if (!opts.frozenColumns) opts.frozenColumns = wrapResult.frozenColumns;
				opts.columns = $.extend(true, [], opts.columns);
				opts.frozenColumns = $.extend(true, [], opts.frozenColumns);
				opts.view = $.extend({}, opts.view);
				$.data(this, 'datagrid', {
					options: opts,
					panel: wrapResult.panel,
					dc: wrapResult.dc,
					ss: wrapResult.ss,
					selectedRows: [],
					checkedRows: [],
					data: {total:0,rows:[]},
					originalRows: [],
					updatedRows: [],
					insertedRows: [],
					deletedRows: []
				});
			}
			
			buildGrid(this);
			
			if (opts.data){
				loadData(this, opts.data);
				initChanges(this);
			} else {
				var data = $.fn.datagrid.parseData(this);
				if (data.total > 0){
					loadData(this, data);
					initChanges(this);
				}
			}
			
			setSize(this);
			request(this);
			bindEvents(this);
		});
	};
	
	var editors = {
		text: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
				return input;
			},
			getValue: function(target){
				return $(target).val();
			},
			setValue: function(target, value){
				$(target).val(value);
			},
			resize: function(target, width){
				$(target)._outerWidth(width)._outerHeight(22);
			}
		},
		textarea: {
			init: function(container, options){
				var input = $('<textarea class="datagrid-editable-input"></textarea>').appendTo(container);
				return input;
			},
			getValue: function(target){
				return $(target).val();
			},
			setValue: function(target, value){
				$(target).val(value);
			},
			resize: function(target, width){
				$(target)._outerWidth(width);
			}
		},
		checkbox: {
			init: function(container, options){
				var input = $('<input type="checkbox">').appendTo(container);
				input.val(options.on);
				input.attr('offval', options.off);
				return input;
			},
			getValue: function(target){
				if ($(target).is(':checked')){
					return $(target).val();
				} else {
					return $(target).attr('offval');
				}
			},
			setValue: function(target, value){
				var checked = false;
				if ($(target).val() == value){
					checked = true;
				}
				$(target)._propAttr('checked', checked);
			}
		},
		numberbox: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
				input.numberbox(options);
				return input;
			},
			destroy: function(target){
				$(target).numberbox('destroy');
			},
			getValue: function(target){
				$(target).blur();
				return $(target).numberbox('getValue');
			},
			setValue: function(target, value){
				$(target).numberbox('setValue', value);
			},
			resize: function(target, width){
				$(target)._outerWidth(width)._outerHeight(22);
			}
		},
		validatebox: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container);
				input.validatebox(options);
				return input;
			},
			destroy: function(target){
				$(target).validatebox('destroy');
			},
			getValue: function(target){
				return $(target).val();
			},
			setValue: function(target, value){
				$(target).val(value);
			},
			resize: function(target, width){
				$(target)._outerWidth(width)._outerHeight(22);
			}
		},
		datebox: {
			init: function(container, options){
				var input = $('<input type="text">').appendTo(container);
				input.datebox(options);
				return input;
			},
			destroy: function(target){
				$(target).datebox('destroy');
			},
			getValue: function(target){
				return $(target).datebox('getValue');
			},
			setValue: function(target, value){
				$(target).datebox('setValue', value);
			},
			resize: function(target, width){
				$(target).datebox('resize', width);
			}
		},
		combobox: {
			init: function(container, options){
				var combo = $('<input type="text">').appendTo(container);
				combo.combobox(options || {});
				return combo;
			},
			destroy: function(target){
				$(target).combobox('destroy');
			},
			getValue: function(target){
				var opts = $(target).combobox('options');
				if (opts.multiple){
					return $(target).combobox('getValues').join(opts.separator);
				} else {
					return $(target).combobox('getValue');
				}
//				return $(target).combobox('getValue');
			},
			setValue: function(target, value){
				var opts = $(target).combobox('options');
				if (opts.multiple){
					if (value){
						$(target).combobox('setValues', value.split(opts.separator));
					} else {
						$(target).combobox('clear');
					}
				} else {
					$(target).combobox('setValue', value);
				}
//				$(target).combobox('setValue', value);
			},
			resize: function(target, width){
				$(target).combobox('resize', width)
			}
		},
		combotree: {
			init: function(container, options){
				var combo = $('<input type="text">').appendTo(container);
				combo.combotree(options);
				return combo;
			},
			destroy: function(target){
				$(target).combotree('destroy');
			},
			getValue: function(target){
				return $(target).combotree('getValue');
			},
			setValue: function(target, value){
				$(target).combotree('setValue', value);
			},
			resize: function(target, width){
				$(target).combotree('resize', width)
			}
		}
	};
	
	$.fn.datagrid.methods = {
		options: function(jq){
			var gopts = $.data(jq[0], 'datagrid').options;
			var popts = $.data(jq[0], 'datagrid').panel.panel('options');
			var opts = $.extend(gopts, {
				width: popts.width,
				height: popts.height,
				closed: popts.closed,
				collapsed: popts.collapsed,
				minimized: popts.minimized,
				maximized: popts.maximized
			});
//			var pager = jq.datagrid('getPager');
//			if (pager.length){
//				var pagerOpts = pager.pagination('options');
//				$.extend(opts, {
//					pageNumber: pagerOpts.pageNumber,
//					pageSize: pagerOpts.pageSize
//				});
//			}
			return opts;
		},
		getPanel: function(jq){
			return $.data(jq[0], 'datagrid').panel;
		},
		getPager: function(jq){
			return $.data(jq[0], 'datagrid').panel.children('div.datagrid-pager');
		},
		getColumnFields: function(jq, frozen){
			return getColumnFields(jq[0], frozen);
		},
		getColumnOption: function(jq, field){
			return getColumnOption(jq[0], field);
		},
		resize: function(jq, param){
			return jq.each(function(){
				setSize(this, param);
			});
		},
		load: function(jq, params){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				opts.pageNumber = 1;
				var pager = $(this).datagrid('getPager');
//				pager.pagination({pageNumber:1});
				pager.pagination('refresh', {pageNumber:1});
				request(this, params);
			});
		},
		reload: function(jq, params){
			return jq.each(function(){
				request(this, params);
			});
		},
		reloadFooter: function(jq, footer){
			return jq.each(function(){
				var opts = $.data(this, 'datagrid').options;
				var dc = $.data(this, 'datagrid').dc;
				if (footer){
					$.data(this, 'datagrid').footer = footer;
				}
				if (opts.showFooter){
					opts.view.renderFooter.call(opts.view, this, dc.footer2, false);
					opts.view.renderFooter.call(opts.view, this, dc.footer1, true);
					if (opts.view.onAfterRender){
						opts.view.onAfterRender.call(opts.view, this);
					}
					$(this).datagrid('fixRowHeight');
				}
			});
		},
		loading: function(jq){
			return jq.each(function(){
				var opts = $.data(this, 'datagrid').options;
				$(this).datagrid('getPager').pagination('loading');
				if (opts.loadMsg){
					var panel = $(this).datagrid('getPanel');
					if (!panel.children('div.datagrid-mask').length){
						$('<div class="datagrid-mask" style="display:block"></div>').appendTo(panel);
						var msg = $('<div class="datagrid-mask-msg" style="display:block;left:50%"></div>').html(opts.loadMsg).appendTo(panel);
//						msg.css('marginLeft', -msg.outerWidth()/2);
						msg._outerHeight(40);
						msg.css({
							marginLeft: (-msg.outerWidth()/2),
							lineHeight: (msg.height()+'px')
						});
					}
				}
			});
		},
		loaded: function(jq){
			return jq.each(function(){
				$(this).datagrid('getPager').pagination('loaded');
				var panel = $(this).datagrid('getPanel');
				panel.children('div.datagrid-mask-msg').remove();
				panel.children('div.datagrid-mask').remove();
			});
		},
		fitColumns: function(jq){
			return jq.each(function(){
				fitColumns(this);
			});
		},
		fixColumnSize: function(jq, field){
			return jq.each(function(){
				fixColumnSize(this, field);
			});
		},
		fixRowHeight: function(jq, index){
			return jq.each(function(){
				fixRowHeight(this, index);
			});
		},
		freezeRow: function(jq, index){
			return jq.each(function(){
				freezeRow(this, index);
			});
		},
		autoSizeColumn: function(jq, field){	// adjusts the column width to fit the contents.
			return jq.each(function(){
				autoSizeColumn(this, field);
			});
		},
		loadData: function(jq, data){
			return jq.each(function(){
				loadData(this, data);
				initChanges(this);
			});
		},
		getData: function(jq){
			return $.data(jq[0], 'datagrid').data;
		},
		getRows: function(jq){
			return $.data(jq[0], 'datagrid').data.rows;
		},
		getFooterRows: function(jq){
			return $.data(jq[0], 'datagrid').footer;
		},
		getRowIndex: function(jq, id){	// id or row record
			return getRowIndex(jq[0], id);
		},
		getChecked: function(jq){
			return getCheckedRows(jq[0]);
		},
		getSelected: function(jq){
			var rows = getSelectedRows(jq[0]);
			return rows.length>0 ? rows[0] : null;
		},
		getSelections: function(jq){
			return getSelectedRows(jq[0]);
		},
		clearSelections: function(jq){
			return jq.each(function(){
				var selectedRows = $.data(this, 'datagrid').selectedRows;
				selectedRows.splice(0, selectedRows.length);
				unselectAll(this);
			});
		},
		clearChecked: function(jq){
			return jq.each(function(){
				var checkedRows = $.data(this, 'datagrid').checkedRows;
				checkedRows.splice(0, checkedRows.length);
				uncheckAll(this);
			});
		},
		scrollTo: function(jq, index){
			return jq.each(function(){
				scrollTo(this, index);
			});
		},
		highlightRow: function(jq, index){
			return jq.each(function(){
				highlightRow(this, index);
				scrollTo(this, index);
			});
		},
		selectAll: function(jq){
			return jq.each(function(){
				selectAll(this);
			});
		},
		unselectAll: function(jq){
			return jq.each(function(){
				unselectAll(this);
			});
		},
		selectRow: function(jq, index){
			return jq.each(function(){
				selectRow(this, index);
			});
		},
		selectRecord: function(jq, id){
			return jq.each(function(){
				var opts = $.data(this, 'datagrid').options;
				if (opts.idField){
					var index = getRowIndex(this, id);
					if (index >= 0){
						$(this).datagrid('selectRow', index);
					}
				}
			});
		},
		unselectRow: function(jq, index){
			return jq.each(function(){
				unselectRow(this, index);
			});
		},
		checkRow: function(jq, index){
			return jq.each(function(){
				checkRow(this, index);
			});
		},
		uncheckRow: function(jq, index){
			return jq.each(function(){
				uncheckRow(this, index);
			});
		},
		checkAll: function(jq){
			return jq.each(function(){
				checkAll(this);
			});
		},
		uncheckAll: function(jq){
			return jq.each(function(){
				uncheckAll(this);
			});
		},
		beginEdit: function(jq, index){
			return jq.each(function(){
				beginEdit(this, index);
			});
		},
		endEdit: function(jq, index){
			return jq.each(function(){
				endEdit(this, index, false);
			});
		},
		cancelEdit: function(jq, index){
			return jq.each(function(){
				endEdit(this, index, true);
			});
		},
		getEditors: function(jq, index){
			return getEditors(jq[0], index);
		},
		getEditor: function(jq, param){	// param: {index:0, field:'name'}
			return getEditor(jq[0], param);
		},
		refreshRow: function(jq, index){
			return jq.each(function(){
				var opts = $.data(this, 'datagrid').options;
				opts.view.refreshRow.call(opts.view, this, index);
			});
		},
		validateRow: function(jq, index){
			return validateRow(jq[0], index);
		},
		updateRow: function(jq, param){	// param: {index:1,row:{code:'code1',name:'name1'}}
			return jq.each(function(){
				var opts = $.data(this, 'datagrid').options;
				opts.view.updateRow.call(opts.view, this, param.index, param.row);
			});
		},
		appendRow: function(jq, row){
			return jq.each(function(){
				appendRow(this, row);
			});
		},
		insertRow: function(jq, param){
			return jq.each(function(){
				insertRow(this, param);
			});
		},
		deleteRow: function(jq, index){
			return jq.each(function(){
				deleteRow(this, index);
			});
		},
		getChanges: function(jq, state){
			return getChanges(jq[0], state);	// state: inserted,deleted,updated
		},
		acceptChanges: function(jq){
			return jq.each(function(){
				acceptChanges(this);
			});
		},
		rejectChanges: function(jq){
			return jq.each(function(){
				rejectChanges(this);
			});
		},
		mergeCells: function(jq, param){
			return jq.each(function(){
				mergeCells(this, param);
			});
		},
		showColumn: function(jq, field){
			return jq.each(function(){
				var panel = $(this).datagrid('getPanel');
				panel.find('td[field="' + field + '"]').show();
				$(this).datagrid('getColumnOption', field).hidden = false;
				$(this).datagrid('fitColumns');
			});
		},
		hideColumn: function(jq, field){
			return jq.each(function(){
				var panel = $(this).datagrid('getPanel');
				panel.find('td[field="' + field + '"]').hide();
				$(this).datagrid('getColumnOption', field).hidden = true;
				$(this).datagrid('fitColumns');
			});
		}
	};
	
	$.fn.datagrid.parseOptions = function(target){
		var t = $(target);
		return $.extend({}, $.fn.panel.parseOptions(target), $.parser.parseOptions(target, [
			'url','toolbar','idField','sortName','sortOrder','pagePosition','resizeHandle',
			{fitColumns:'boolean',autoRowHeight:'boolean',striped:'boolean',nowrap:'boolean'},
			{rownumbers:'boolean',singleSelect:'boolean',checkOnSelect:'boolean',selectOnCheck:'boolean'},
			{pagination:'boolean',pageSize:'number',pageNumber:'number'},
			{multiSort:'boolean',remoteSort:'boolean',showHeader:'boolean',showFooter:'boolean'},
			{scrollbarSize:'number'}
		]), {
			pageList: (t.attr('pageList') ? eval(t.attr('pageList')) : undefined),
			loadMsg: (t.attr('loadMsg')!=undefined ? t.attr('loadMsg') : undefined),
			rowStyler: (t.attr('rowStyler') ? eval(t.attr('rowStyler')) : undefined)
		});
	};
	
	$.fn.datagrid.parseData = function(target){
		var t = $(target);
		var data = {
			total:0,
			rows:[]
		};
		var fields = t.datagrid('getColumnFields',true).concat(t.datagrid('getColumnFields',false));
		t.find('tbody tr').each(function(){
			data.total++;
			var row = {};
			$.extend(row, $.parser.parseOptions(this,['iconCls','state']));
			for(var i=0; i<fields.length; i++){
				row[fields[i]] = $(this).find('td:eq('+i+')').html();
			}
			data.rows.push(row);
		});
		return data;
	};
	
	var defaultView = {
		render: function(target, container, frozen){
			var state = $.data(target, 'datagrid');
			var opts = state.options;
			var rows = state.data.rows;
			var fields = $(target).datagrid('getColumnFields', frozen);
			
			if (frozen){
				if (!(opts.rownumbers || (opts.frozenColumns && opts.frozenColumns.length))){
					return;
				}
			}
			
			var table = ['<table class="datagrid-btable" cellspacing="0" cellpadding="0" border="0"><tbody>'];
			for(var i=0; i<rows.length; i++) {
				// get the class and style attributes for this row
				var css = opts.rowStyler ? opts.rowStyler.call(target, i, rows[i]) : '';
				var classValue = '';
				var styleValue = '';
				if (typeof css == 'string'){
					styleValue = css;
				} else if (css){
					classValue = css['class'] || '';
					styleValue = css['style'] || '';
				}
				
				var cls = 'class="datagrid-row ' + (i % 2 && opts.striped ? 'datagrid-row-alt ' : ' ') + classValue + '"';
				var style = styleValue ? 'style="' + styleValue + '"' : '';
				var rowId = state.rowIdPrefix + '-' + (frozen?1:2) + '-' + i;
				table.push('<tr id="' + rowId + '" datagrid-row-index="' + i + '" ' + cls + ' ' + style + '>');
				table.push(this.renderRow.call(this, target, fields, frozen, i, rows[i]));
				table.push('</tr>');
			}
			table.push('</tbody></table>');
			
			$(container).html(table.join(''));
		},
		
		renderFooter: function(target, container, frozen){
			var opts = $.data(target, 'datagrid').options;
			var rows = $.data(target, 'datagrid').footer || [];
			var fields = $(target).datagrid('getColumnFields', frozen);
			var table = ['<table class="datagrid-ftable" cellspacing="0" cellpadding="0" border="0"><tbody>'];
			
			for(var i=0; i<rows.length; i++){
				table.push('<tr class="datagrid-row" datagrid-row-index="' + i + '">');
				table.push(this.renderRow.call(this, target, fields, frozen, i, rows[i]));
				table.push('</tr>');
			}
			
			table.push('</tbody></table>');
			$(container).html(table.join(''));
		},
		
		renderRow: function(target, fields, frozen, rowIndex, rowData){
			var opts = $.data(target, 'datagrid').options;
			
			var cc = [];
			if (frozen && opts.rownumbers){
				var rownumber = rowIndex + 1;
				if (opts.pagination){
					rownumber += (opts.pageNumber-1)*opts.pageSize;
				}
				cc.push('<td class="datagrid-td-rownumber"><div class="datagrid-cell-rownumber">'+rownumber+'</div></td>');
			}
			for(var i=0; i<fields.length; i++){
				var field = fields[i];
				var col = $(target).datagrid('getColumnOption', field);
				if (col){
					var value = rowData[field];	// the field value
					var css = col.styler ? (col.styler(value, rowData, rowIndex)||'') : '';
					var classValue = '';
					var styleValue = '';
					if (typeof css == 'string'){
						styleValue = css;
					} else if (cc){
						classValue = css['class'] || '';
						styleValue = css['style'] || '';
					}
					var cls = classValue ? 'class="' + classValue + '"' : '';
					var style = col.hidden ? 'style="display:none;' + styleValue + '"' : (styleValue ? 'style="' + styleValue + '"' : '');
					
					cc.push('<td field="' + field + '" ' + cls + ' ' + style + '>');
					
					if (col.checkbox){
						var style = '';
					} else {
						var style = styleValue;
						if (col.align){style += ';text-align:' + col.align + ';'}
						if (!opts.nowrap){
							style += ';white-space:normal;height:auto;';
						} else if (opts.autoRowHeight){
							style += ';height:auto;';
						}
					}
					
					cc.push('<div style="' + style + '" ');
					cc.push(col.checkbox ? 'class="datagrid-cell-check"' : 'class="datagrid-cell ' + col.cellClass + '"');
					cc.push('>');
					
					if (col.checkbox){
						cc.push('<input type="checkbox" name="' + field + '" value="' + (value!=undefined ? value : '') + '">');
					} else if (col.formatter){
						cc.push(col.formatter(value, rowData, rowIndex));
					} else {
						cc.push(value);
					}
					
					cc.push('</div>');
					cc.push('</td>');
				}
			}
			return cc.join('');
		},
		
		refreshRow: function(target, rowIndex){
			this.updateRow.call(this, target, rowIndex, {});
		},
		
		updateRow: function(target, rowIndex, row){
			var opts = $.data(target, 'datagrid').options;
			var rows = $(target).datagrid('getRows');
			$.extend(rows[rowIndex], row);
			var css = opts.rowStyler ? opts.rowStyler.call(target, rowIndex, rows[rowIndex]) : '';
			var classValue = '';
			var styleValue = '';
			if (typeof css == 'string'){
				styleValue = css;
			} else if (css){
				classValue = css['class'] || '';
				styleValue = css['style'] || '';
			}
			var classValue = 'datagrid-row ' + (rowIndex % 2 && opts.striped ? 'datagrid-row-alt ' : ' ') + classValue;
			
			function _update(frozen){
				var fields = $(target).datagrid('getColumnFields', frozen);
				var tr = opts.finder.getTr(target, rowIndex, 'body', (frozen?1:2));
				var checked = tr.find('div.datagrid-cell-check input[type=checkbox]').is(':checked');
				tr.html(this.renderRow.call(this, target, fields, frozen, rowIndex, rows[rowIndex]));
//				tr.attr('style', styleValue).attr('class', classValue);
				tr.attr('style', styleValue).attr('class', tr.hasClass('datagrid-row-selected')?classValue+' datagrid-row-selected':classValue);
				if (checked){
					tr.find('div.datagrid-cell-check input[type=checkbox]')._propAttr('checked', true);
				}
			}
			
			_update.call(this, true);
			_update.call(this, false);
			$(target).datagrid('fixRowHeight', rowIndex);
		},
		
		insertRow: function(target, index, row){
			var state = $.data(target, 'datagrid');
			var opts = state.options;
			var dc = state.dc;
			var data = state.data;
			
			if (index == undefined || index == null) index = data.rows.length;
			if (index > data.rows.length) index = data.rows.length;
			
			function _incIndex(frozen){
				var serno = frozen?1:2;
				for(var i=data.rows.length-1; i>=index; i--){
					var tr = opts.finder.getTr(target, i, 'body', serno);
					tr.attr('datagrid-row-index', i+1);
					tr.attr('id', state.rowIdPrefix + '-' + serno + '-' + (i+1));
					if (frozen && opts.rownumbers){
						var rownumber = i+2;
						if (opts.pagination){
							rownumber += (opts.pageNumber-1)*opts.pageSize;
						}
						tr.find('div.datagrid-cell-rownumber').html(rownumber);
					}
					if (opts.striped){
						tr.removeClass('datagrid-row-alt').addClass((i+1)%2 ? 'datagrid-row-alt' : '');
					}
				}
			}
			
			function _insert(frozen){
				var serno = frozen?1:2;
				var fields = $(target).datagrid('getColumnFields', frozen);
				var rowId = state.rowIdPrefix + '-' + serno + '-' + index;
				var tr = '<tr id="' + rowId + '" class="datagrid-row" datagrid-row-index="' + index + '"></tr>';
//				var tr = '<tr id="' + rowId + '" class="datagrid-row" datagrid-row-index="' + index + '">' + this.renderRow.call(this, target, fields, frozen, index, row) + '</tr>';
				if (index >= data.rows.length){	// append new row
					if (data.rows.length){	// not empty
						opts.finder.getTr(target, '', 'last', serno).after(tr);
					} else {
						var cc = frozen ? dc.body1 : dc.body2;
						cc.html('<table cellspacing="0" cellpadding="0" border="0"><tbody>' + tr + '</tbody></table>');
					}
				} else {	// insert new row
					opts.finder.getTr(target, index+1, 'body', serno).before(tr);
				}
			}
			
			_incIndex.call(this, true);
			_incIndex.call(this, false);
			_insert.call(this, true);
			_insert.call(this, false);
			
			data.total += 1;
			data.rows.splice(index, 0, row);
			
			this.refreshRow.call(this, target, index);
		},
		
		deleteRow: function(target, index){
			var state = $.data(target, 'datagrid');
			var opts = state.options;
			var data = state.data;
			
			function _decIndex(frozen){
				var serno = frozen?1:2;
				for(var i=index+1; i<data.rows.length; i++){
					var tr = opts.finder.getTr(target, i, 'body', serno);
					tr.attr('datagrid-row-index', i-1);
					tr.attr('id', state.rowIdPrefix + '-' + serno + '-' + (i-1));
					if (frozen && opts.rownumbers){
						var rownumber = i;
						if (opts.pagination){
							rownumber += (opts.pageNumber-1)*opts.pageSize;
						}
						tr.find('div.datagrid-cell-rownumber').html(rownumber);
					}
					if (opts.striped){
						tr.removeClass('datagrid-row-alt').addClass((i-1)%2 ? 'datagrid-row-alt' : '');
					}
				}
			}
			
			opts.finder.getTr(target, index).remove();
			_decIndex.call(this, true);
			_decIndex.call(this, false);
			
			data.total -= 1;
			data.rows.splice(index,1);
		},
		
		onBeforeRender: function(target, rows){},
		onAfterRender: function(target){
			var opts = $.data(target, 'datagrid').options;
			if (opts.showFooter){
				var footer = $(target).datagrid('getPanel').find('div.datagrid-footer');
				footer.find('div.datagrid-cell-rownumber,div.datagrid-cell-check').css('visibility', 'hidden');
			}
		}
	};
	
	$.fn.datagrid.defaults = $.extend({}, $.fn.panel.defaults, {
		frozenColumns: undefined,
		columns: undefined,
		fitColumns: false,
		resizeHandle: 'right',	// left,right,both
		autoRowHeight: true,
		toolbar: null,
		striped: false,
		method: 'post',
		nowrap: true,
		idField: null,
		url: null,
		data: null,
		loadMsg: 'Processing, please wait ...',
		rownumbers: false,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: false,
		pagePosition: 'bottom',	// top,bottom,both
		pageNumber: 1,
		pageSize: 10,
		pageList: [10,20,30,40,50],
		queryParams: {},
		sortName: null,
		sortOrder: 'asc',
		multiSort: false,
		remoteSort: true,
		showHeader: true,
		showFooter: false,
		scrollbarSize: 18,
		rowStyler: function(rowIndex, rowData){},	// return style such as 'background:red'
		loader: function(param, success, error){
			var opts = $(this).datagrid('options');
			if (!opts.url) return false;
			$.ajax({
				type: opts.method,
				url: opts.url,
				data: param,
				dataType: 'json',
				success: function(data){
					success(data);
				},
				error: function(){
					error.apply(this, arguments);
				}
			});
		},
		loadFilter: function(data){
			if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
				return {
					total: data.length,
					rows: data
				};
			} else {
				return data;
			}
		},
		
		editors: editors,
		finder:{
			getTr:function(target, index, type, serno){
				type = type || 'body';
				serno = serno || 0;
				var state = $.data(target, 'datagrid');
				var dc = state.dc;	// data container
				var opts = state.options;
				if (serno == 0){
					var tr1 = opts.finder.getTr(target, index, type, 1);
					var tr2 = opts.finder.getTr(target, index, type, 2);
					return tr1.add(tr2);
				} else {
					if (type == 'body'){
						var tr = $('#' + state.rowIdPrefix + '-' + serno + '-' + index);
						if (!tr.length){
							tr = (serno==1?dc.body1:dc.body2).find('>table>tbody>tr[datagrid-row-index='+index+']');
						}
						return tr;
					} else if (type == 'footer'){
						return (serno==1?dc.footer1:dc.footer2).find('>table>tbody>tr[datagrid-row-index='+index+']');
					} else if (type == 'selected'){
						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr.datagrid-row-selected');
					} else if (type == 'highlight'){
						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr.datagrid-row-over');
					} else if (type == 'checked'){
						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr.datagrid-row-checked');
//						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr.datagrid-row:has(div.datagrid-cell-check input:checked)');
					} else if (type == 'last'){
						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr[datagrid-row-index]:last');
					} else if (type == 'allbody'){
						return (serno==1?dc.body1:dc.body2).find('>table>tbody>tr[datagrid-row-index]');
					} else if (type == 'allfooter'){
						return (serno==1?dc.footer1:dc.footer2).find('>table>tbody>tr[datagrid-row-index]');
					}
				}
			},
			getRow:function(target, p){	// p can be row index or tr object
				var index = (typeof p == 'object') ? p.attr('datagrid-row-index') : p;
				return $.data(target, 'datagrid').data.rows[parseInt(index)];
			}
		},
		view: defaultView,
		
		onBeforeLoad: function(param){},
		onLoadSuccess: function(){},
		onLoadError: function(){},
		onClickRow: function(rowIndex, rowData){},
		onDblClickRow: function(rowIndex, rowData){},
		onClickCell: function(rowIndex, field, value){},
		onDblClickCell: function(rowIndex, field, value){},
		onSortColumn: function(sort, order){},
		onResizeColumn: function(field, width){},
		onSelect: function(rowIndex, rowData){},
		onUnselect: function(rowIndex, rowData){},
		onSelectAll: function(rows){},
		onUnselectAll: function(rows){},
		onCheck: function(rowIndex, rowData){},
		onUncheck: function(rowIndex, rowData){},
		onCheckAll: function(rows){},
		onUncheckAll: function(rows){},
		onBeforeEdit: function(rowIndex, rowData){},
		onAfterEdit: function(rowIndex, rowData, changes){},
		onCancelEdit: function(rowIndex, rowData){},
		onHeaderContextMenu: function(e, field){},
		onRowContextMenu: function(e, rowIndex, rowData){}
	});
})(jQuery);
