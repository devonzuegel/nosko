class ActivityLog
  def initialize(user)
    @user = user
  end

  def unreviewed
    rendered(findings.select { |f| !f.reviewed })
  end

  def reviewed
    rendered(findings.select { |f| f.reviewed })
  end

  private

  def findings
    @raw_findings ||= Finding::Collection.new(@user).all
    @findings = @raw_findings.map { |finding| finding.decorate }
  end

  def rendered(list)
    list.map { |f| f.as_prop }
  end
end
