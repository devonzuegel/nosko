R = React.DOM
TransitionGroup = React.addons.CSSTransitionGroup


@ActivityLog = React.createClass
  mixins: [ HotkeysModal]

  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired
    # TODO need to actually persist the reviewing

  getInitialState: ->
    findings:   @props.findings
    active_id:  0
    selected:   [0]
    selecting:  false

  componentDidMount: ->
    Mousetrap.bind 'down',      (e) => @to_next_finding(e)
    Mousetrap.bind 'up',        (e) => @to_prev_finding(e)
    Mousetrap.bind 'right',     (e) => @archive_finding(e)
    Mousetrap.bind 'ctrl+down', (e) => @to_last_finding(e)
    Mousetrap.bind 'ctrl+up',   (e) => @to_first_finding(e)

    Mousetrap.bind 'shift',     (e) =>
      @setState selecting: true
    Mousetrap.bind 'shift',     (e) =>
      @setState selecting: false
    , 'keyup'

  buttons: ->
    R.div className: 'btn-toolbar',
      R.div className: 'btn-group pull-right', role: 'group',
        @hotkeys_modal_btn()
        R.button className: 'btn btn-secondary', onClick: @handleAdd,
          Utils.ion_icon_link('ios-plus-outline', null, 'Add Item')
        R.button className: 'btn btn-secondary', onClick: @select_all,
          Utils.ion_icon_link('ios-checkmark-outline', null, 'Select all')

  label_class: (finding) ->
    switch finding.visibility
      when 'Only me' then 'label-primary'
      when 'Friends' then 'label-info'
      when 'Public'  then 'label-success'
      else 'label-default'

  rendered_findings: ->
    @state.findings.map (finding, id) =>
      active_class = if (id in @state.selected) then 'active' else 'inactive'
      R.li
        onClick:    @handleClick.bind(this, id)
        key:        finding.to_param
        id:         @finding_id(id)
        className:  "list-group-item #{active_class}"

        finding.title
        R.span
          className: "label #{@label_class(finding)} pull-right"
          finding.visibility
        R.span className: 'pull-right date', finding.updated_at

  rand_str:        -> Math.random().toString(36).substring(7)
  finding_id: (id) -> "list-group-item-#{id}"

  handleAdd: ->
    new_findings = @state.findings.concat([{ title: @rand_str(), to_param: @rand_str() }])
    @setState findings: new_findings

  handleRemove: (i) ->
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
    for id in @state.selected
      @handleRemove(id)
    new_selected = [ @state.selected[0] ]
    @setState selected: []  # Set none as selected until slide out is over
    setTimeout =>
      @setState selected: new_selected
    , 350

  render: ->
    @reset_active_id()
    R.div id: 'activity-log', className: 'list-group',
      @buttons()
      R.ul className: 'list-group',
        React.createElement TransitionGroup,
          transitionName:          'slide'
          transitionEnterTimeout:   0
          transitionLeaveTimeout:  300
          @rendered_findings()