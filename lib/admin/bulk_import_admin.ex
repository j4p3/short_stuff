defmodule ShortStuff.Subscriptions.BulkImportAdmin do
  def after_save(_conn, bulk_import) do
    {:ok, _pid} = Task.start_link(ShortStuff.Subscriptions.Importer, :stream_s3_file, [bulk_import.bucket_name, bulk_import.file_path])
    {:ok, bulk_import}
  end
end
