class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    en_account = EvernoteAccount.find(en_account_id)
    en_account.each_stale_note do |stale_note|
      # Do something
    end
  end
end