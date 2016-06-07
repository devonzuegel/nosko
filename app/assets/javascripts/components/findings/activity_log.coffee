R = React.DOM
TransitionGroup = React.addons.CSSTransitionGroup

@ActivityLog = React.createClass
  mixins: [ HotkeysModal]

  propTypes:
    findings:                React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired
    share_by_default_enums:  React.PropTypes.arrayOf(React.PropTypes.string).isRequired

  getInitialState: ->
    findings:   @props.findings
    active_id:  0
    selected:   if (@props.findings.length == 0) then [] else [0]
    selecting:  false

  componentDidMount: ->
    Mousetrap.bind 'down',      (e) => @to_next_finding(e)
    Mousetrap.bind 'up',        (e) => @to_prev_finding(e)
    Mousetrap.bind 'right',     (e) => @archive_finding(e)
    Mousetrap.bind 'ctrl+down', (e) => @to_last_finding(e)
    Mousetrap.bind 'ctrl+up',   (e) => @to_first_finding(e)

    Mousetrap.bind 'shift',     (e) =>
      $(document).bind('selectstart', Utils.return_false)
      @setState selecting: true
    , 'keypress'
    Mousetrap.bind 'shift',     (e) =>
      $(document).unbind('selectstart', Utils.return_false)
      @setState selecting: false
    , 'keyup'

    $(document).click (event) =>
      if !$(event.target).closest('#activity-log').length and !$(event.target).is('#activity-log')
        @setState selected: [@state.active_id]

  finding_id: (id) -> "list-group-item-#{id}"
  selectability_klass: -> if @state.selecting then 'no-select' else 'select-enabled'

  handleRemove: (i) ->
    data = { article: { reviewed: true } }
    $.patch "/finding/#{@state.findings[i].to_param}", data, (result) =>
      new_findings = @state.findings.slice()
      new_findings.splice(i, 1)
      @setState findings: new_findings

  reset_active_id: ->
    if (@state.findings.length - 1 < @state.active_id)
      @setState(active_id: @state.findings.length - 1)

  to_next_finding: (e) ->
    e.preventDefault()
    if @state.active_id < @state.findings.length - 1
      new_active_id = @state.active_id + 1
      @setState
        active_id: new_active_id
        selected:  [new_active_id]
    Utils.scroll_to(@finding_id(@state.active_id))

  to_prev_finding: (e) ->
    e.preventDefault()
    if @state.active_id > 0
      new_active_id = @state.active_id - 1
      @setState
        active_id: new_active_id
        selected:  [new_active_id]
    Utils.scroll_to(@finding_id(@state.active_id))

  select_all: ->
    @setState selected: [0..@state.findings.length - 1]

  handleClick: (i) ->
    @setState active_id:  i
    if not @state.selecting
      @setState selected: [i]
    else if (i in @state.selected)
      @setState selected: @state.selected.filter (j) -> j isnt i
    else
      @setState selected: @state.selected.concat([ @state.active_id..i ]).sort().unique()

  archive_finding: (e) ->
    e.preventDefault()
    new_selected = if (@state.findings.length == @state.selected.length) then [] else [ @state.selected[0] ]
    for id in @state.selected.reverse()  # Don't mess up the indices before removing all
      @handleRemove(id)
    @setState selected: []  # Set none as selected until slide out is over
    setTimeout =>
      @setState selected: new_selected
    , 350

  mass_visibility_change_btn: ->
    R.button className: 'btn btn-secondary', id: 'mass-visibility-update',
      React.createElement Dropdown,
        id:                  "dropdown-mass-visibility-update"
        option_labels:       @props.share_by_default_enums
        dropdownClasses:     'pull-right'
        menuClasses:         'centerDropdown'
        onItemClick: (label) =>
          for id in @state.selected
            @update_visibility(label, id)
        toggleBtn:           =>
          React.DOM.div className: 'card-button',
            Utils.ion_icon('eye', 'inline-block')
            React.DOM.div className: 'icon-text inline-block', "Change visibility (#{@state.selected.length})"

  buttons: ->
    R.div className: 'btn-toolbar',
      R.div className: 'btn-group pull-right', role: 'group',
        @mass_visibility_change_btn()
        @hotkeys_modal_btn()
        R.button className: 'btn btn-secondary', onClick: @select_all,
          Utils.ion_icon_link('ios-checkmark-outline', null, 'Select all')

  label_class: (finding) ->
    switch finding.visibility
      when 'Only me' then 'label-primary'
      when 'Friends' then 'label-info'
      when 'Public'  then 'label-success'
      else                'label-default'

  update_visibility: (visibility, i) ->
    new_findings = @state.findings.slice()
    new_findings[i].visibility = visibility
    @setState(findings: new_findings)

    $.patch "/finding/#{@state.findings[i].to_param}", { article: { visibility: visibility } }

  # visibility_btn: (i) ->
  #   finding = @state.findings[i]
  #   React.createElement Dropdown,
  #     id:                  "dropdown-#{finding.to_param}"
  #     header:              'Change visibility'
  #     option_labels:       @props.share_by_default_enums
  #     active_label:        finding.visibility
  #     dropdownClasses:     'pull-right'
  #     menuClasses:         'centerDropdown'
  #     onItemClick: (label) => @update_visibility(label, i)
  #     toggleBtn:           =>
  #       R.span
  #         className: "label #{@label_class(finding)} pull-right"
  #         finding.visibility

  rendered_findings: ->
    @state.findings.map (finding, id) =>
      selected_class = if (id in @state.selected) then 'selected' else 'unselected'
      React.DOM.div
        onClick:    @handleClick.bind(this, id)
        key:        finding.to_param
        id:         @finding_id(id)
        className:  "finding #{selected_class}"

        R.span
          className: "label #{@label_class(finding)} pull-right"
          finding.visibility
        R.span className: 'pull-right date', "Created #{finding.created_at}"
        R.div className: 'title', finding.title

  render: ->
    @reset_active_id()
    R.div id: 'activity-log', className: "findings-stream activity-log #{@selectability_klass()}",
      @buttons()
      if @state.findings.length == 0
        R.div className: 'disabled', 'No findings to review!'
      React.createElement TransitionGroup,
        transitionName:          'slide'
        transitionEnterTimeout:   0
        transitionLeaveTimeout:  300
        @rendered_findings()