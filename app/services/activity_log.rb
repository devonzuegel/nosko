class ActivityLog
  def initialize(user)
    @user = user
  end

  def unreviewed
    findings.select { |f| !f.reviewed }
  end

  def reviewed
    findings.select { |f| f.reviewed }
  end

  private

  def findings
    @raw_findings ||= Finding::Collection.new(@user).all
    @findings = @raw_findings.map { |finding| finding.decorate }
  end
end
