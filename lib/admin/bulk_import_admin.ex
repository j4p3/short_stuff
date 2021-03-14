defmodule ShortStuff.Subscriptions.BulkImportAdmin do
  def after_save(_conn, bulk_import) do
    {:ok, _pid} = Task.start(ShortStuff.Subscriptions.Importer, :import_file, [:s3, bulk_import.bucket_name, bulk_import.file_path])
    {:ok, bulk_import}
  end
end
