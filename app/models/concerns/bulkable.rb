module Bulkable
  extend ActiveSupport::Concern

  included do
    def self.to_xlsx
      attributes = %w[id name email created_at updated_at]

      p = Axlsx::Package.new
      wb = p.workbook
      wb.add_worksheet(name: "Users") do |sheet|
        # Define styles
        header_style = wb.styles.add_style(b: true, alignment: { horizontal: :center },
                                                    border: { style: :thin, color: "000000" })
        even_row_style = wb.styles.add_style(bg_color: "DDDDDD",
                                            border: { style: :thin, color: "000000" })
        odd_row_style = wb.styles.add_style(bg_color: "FFFFFF",
                                            border: { style: :thin, color: "000000" })
        summary_style = wb.styles.add_style(b: true, alignment: { horizontal: :right },
                                              border: { style: :thin, color: "000000" })

        # Add header row with style
        sheet.add_row attributes, style: header_style

        # Freeze the header row
        sheet.sheet_view.pane do |pane|
          pane.top_left_cell = "A2"
          pane.state = :frozen_split
          pane.y_split = 1
        end
        # Add filters to the header row
        sheet.auto_filter = "A1:E1"

        # Add data rows with alternating styles
        all.each_with_index do |user, index|
          row_style = index.even? ? even_row_style : odd_row_style
          row_data = attributes.map do |attr|
          if %w[created_at updated_at].include?(attr)
            user.send(attr).strftime("%Y-%m-%d %H:%M:%S")
          else
            user.send(attr)
          end
        end
        sheet.add_row row_data, style: row_style
        end
        # Add summary row
        total_users = all.count
        sheet.add_row [ "Total Users", total_users ], style: summary_style, height: 20
      end
      p.to_stream.read
    end

    def self.to_zip
      xlsx_data = to_xlsx

      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        zos.put_next_entry "users-#{Date.today}.xlsx"
        zos.print xlsx_data
      end
      compressed_filestream.rewind
      compressed_filestream.read
    end
  end
  
end