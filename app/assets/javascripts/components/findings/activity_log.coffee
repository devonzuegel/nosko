R = React.DOM
TransitionGroup = React.addons.CSSTransitionGroup

@ActivityLog = React.createClass
  mixins: [HotkeysModal]

  propTypes:
    findings: React.PropTypes.arrayOf(React.PropTypes.ArticleFacade).isRequired
    # TODO need to actually persist the reviewing

  getInitialState: ->
    findings:   @props.findings
    active_id:  0
    selected:   [0]

  componentDidMount: ->
    Mousetrap.bind 'down',      (e) => @to_next_finding(e)
    Mousetrap.bind 'up',        (e) => @to_prev_finding(e)
    Mousetrap.bind 'right',     (e) => @archive_finding(e)
    Mousetrap.bind 'ctrl+down', (e) => @to_last_finding(e)
    Mousetrap.bind 'ctrl+up',   (e) => @to_first_finding(e)

  buttons: ->
    R.div className: 'btn-toolbar',
      R.div className: 'btn-group pull-right', role: 'group',
        @hotkeys_modal_btn()
        R.button className: 'btn btn-secondary', onClick: @handleAdd,
          Utils.ion_icon_link('ios-plus-outline', null, 'Add Item')

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
        onClick:    @handleRemove.bind(this, id)
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

  archive_finding: (e) ->
    e.preventDefault()
    @handleRemove(@state.active_id)

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