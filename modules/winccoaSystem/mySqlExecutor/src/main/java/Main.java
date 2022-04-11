import io.jaegertracing.Configuration;
import io.jaegertracing.internal.JaegerTracer;
import io.opentracing.Span;
import io.opentracing.Tracer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Main
{
    private final Tracer tracer;

    /**
     * Constructor
     * @param tracer
     */
    public Main(Tracer tracer)
    {
        this.tracer = tracer;
    }

    /**
     * init jaeger tracer
     * @param service
     * @return
     */
    public static JaegerTracer initTracer(String service)
    {
        Configuration.SamplerConfiguration samplerConfig = Configuration.SamplerConfiguration.fromEnv().withType("const").withParam(1);
        Configuration.ReporterConfiguration reporterConfig = Configuration.ReporterConfiguration.fromEnv().withLogSpans(true);
        Configuration config = new Configuration(service).withSampler(samplerConfig).withReporter(reporterConfig);
        return config.getTracer();
    }

    /**
     * execute query method
     * @param url
     * @param user
     * @param password
     * @param query
     */
    private void executeQuery(String url, String user, String password, String query) {
        Span span = tracer.buildSpan("execute-sql-statement").start();

        span.setTag("sql-statement", query);

        try(Connection conn = DriverManager.getConnection(url, user, password))
        {
            Statement stmt = conn.createStatement();

            for(var part : query.split(";"))
                stmt.addBatch(part);

            stmt.executeBatch();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }

        span.finish();
    }

    /**
     * Main function
     * @param args
     */
    public static void main(String[] args)
    {
        Tracer tracer = initTracer("mySqlExecutor");//init tracer
        new Main(tracer).executeQuery(args[0], args[1], args[2], args[3]);//execute tracer
    }
}
