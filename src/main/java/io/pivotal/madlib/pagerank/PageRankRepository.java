package io.pivotal.madlib.pagerank;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public
class PageRankRepository {

    private JdbcTemplate jdbcTemplate;
    
    public PageRankRepository(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    public
    List<PageRankRecord> getTopNRanked(Integer topN) {
        String query = "SELECT dest_address, pagerank FROM pagerank_out ORDER BY 2 DESC ";
        
        if (topN > 0) {
            query = query + " LIMIT " + topN.toString();
        }
        
        List<PageRankRecord> results = new ArrayList<PageRankRecord>();
        
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(query);
        
        for (Map<String, Object> row : rows) {
            Long uniqueId = Long.parseLong(((String)row.get("dest_address")).replace(".", ""));
            PageRankRecord r = new PageRankRecord(uniqueId,
                    (String)row.get("dest_address"), 
                    (Double)row.get("pagerank"));
            results.add(r);
        }
        
        return results;
    }
    
    public
    List<Edge> getNEdges(Integer topN) {
        String query = "SELECT distinct dest_address AS target, src_address AS source" 
                + " FROM nfint ";
        
        if (topN > 0) {
            query = query + " LIMIT " + topN.toString();
        }
        
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(query);
        
        List<Edge> results = new ArrayList<Edge>();
        
        for (Map<String, Object> row : rows) {
            Long t = Long.parseLong(((String)row.get("target")).replace(".", ""));
            Long s = Long.parseLong(((String)row.get("source")).replace(".", ""));
            Edge r = new Edge(t, s);
            
            results.add(r);
        }
        
        return results;
    }

}
