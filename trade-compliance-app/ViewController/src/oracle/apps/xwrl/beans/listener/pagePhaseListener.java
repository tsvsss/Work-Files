package oracle.apps.xwrl.beans.listener;

import javax.faces.event.PhaseEvent;
import javax.faces.event.PhaseId;
import javax.faces.event.PhaseListener;

import oracle.adf.share.logging.ADFLogger;


public class pagePhaseListener implements PhaseListener {


    // T20221205.0039 - TC - Party Attribute - Country Codes
    // Created if needed for debugging purposes

    private static ADFLogger LOGGER = ADFLogger.createADFLogger(pagePhaseListener.class);
    @Override
    public PhaseId getPhaseId() {
        return PhaseId.RENDER_RESPONSE;
    }

    @Override
    public void beforePhase(PhaseEvent event) {
        // Do your job here which should run right before the RENDER_RESPONSE.
        LOGGER.finest("beforePhase");
    }

    @Override
    public void afterPhase(PhaseEvent event) {
        // Do your job here which should run right after the RENDER_RESPONSE.
        LOGGER.finest("afterPhase");
    }

}
