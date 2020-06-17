using System;
using System.Data.SqlTypes;
using System.Text;
using System.Xml;
using System.IO;

public sealed class StringWriterWithEncoding : StringWriter
{
    private readonly Encoding encoding;

    public StringWriterWithEncoding(Encoding encoding)
    {
        this.encoding = encoding;
    }

    public override Encoding Encoding
    {
        get { return encoding; }
    }
}

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void XMLExport(SqlXml InputXml, SqlString OutputFile)
    {
        try
        {
            if (!InputXml.IsNull && !OutputFile.IsNull)
            {

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(InputXml.Value);

                StringWriterWithEncoding sw = new StringWriterWithEncoding(System.Text.Encoding.UTF8);
                XmlWriterSettings settings = new XmlWriterSettings
                {
                    Indent = true,
                    IndentChars = "  ",
                    NewLineChars = "\r\n",
                    NewLineHandling = NewLineHandling.Replace,
                    Encoding = System.Text.Encoding.UTF8
                };

                using (XmlWriter writer = XmlWriter.Create(sw, settings))
                {
                    doc.Save(writer);
                }


                System.IO.File.WriteAllText(OutputFile.ToString(), sw.ToString(), System.Text.Encoding.UTF8);
            }
            else
            {
                throw new Exception("Parameters must be set");
            }
        }
        catch
        {
            throw;
        }
    }

}
