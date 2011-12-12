module Migrations

  module ForeignKeys

    def foreign_key(from_table, from_column, to_table)
      constraint_name = "fk_#{from_table}_#{from_column}"
      execute([
        "ALTER TABLE #{from_table} ADD CONSTRAINT #{constraint_name}",
        "FOREIGN KEY (#{from_column}) REFERENCES #{to_table}(id)"
      ].join("\n"))
    end

    def drop_foreign_key(from_table, from_column)
      constraint_name = "fk_#{from_table}_#{from_column}"
      execute("ALTER TABLE #{from_table} DROP CONSTRAINT #{constraint_name}")
    end

  end

end