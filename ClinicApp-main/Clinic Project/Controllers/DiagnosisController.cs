using Clinic_Project.Dtos.AI;
using Clinic_Project.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Clinic_Project.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class DiagnosisController : ControllerBase
    {
        private readonly IAIService _aiService;

        public DiagnosisController(IAIService aiService)
        {
            _aiService = aiService;
        }

        /// <summary>
        /// Run a disease prediction via the FastAPI AI service.
        /// </summary>
        /// <remarks>
        /// Send the disease type and patient features. The backend forwards the
        /// request to the internal FastAPI micro-service and returns the result.
        ///
        /// **Diabetes features:** HbA1c_level, blood_glucose_level, age, bmi,
        /// smoking_history, hypertension, gender, heart_disease
        ///
        /// **Heart features:** HadAngina, ChestScan, HadStroke, DifficultyWalking,
        /// HadDiabetes, GeneralHealth, HadArthritis, PneumoVaxEver,
        /// RemovedTeeth, AgeCategory, SmokerStatus, BMI, HadKidneyDisease, HadCOPD
        ///
        /// **Kidney features:** age, bp, sg, al, su, rbc, pc, pcc, ba,
        /// bgr, bu, sc, sod, pot, hemo, pcv, wc, rc,
        /// htn, dm, cad, appet, pe, ane
        /// </remarks>
        [HttpPost("predict")]
        [ProducesResponseType(typeof(PredictionResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status503ServiceUnavailable)]
        public async Task<IActionResult> Predict([FromBody] PredictionRequestDto request)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _aiService.PredictAsync(request);

            if (!result.Success)
            {
                return result.ErrorType switch
                {
                    Helpers.enErrorType.BadRequest => BadRequest(result.ErrorMessage),
                    _ => StatusCode(StatusCodes.Status503ServiceUnavailable, result.ErrorMessage),
                };
            }

            return Ok(result.Data);
        }

        /// <summary>
        /// Check whether the FastAPI AI service is reachable and which models are loaded.
        /// </summary>
        [HttpGet("health")]
        [ProducesResponseType(typeof(AIHealthResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status503ServiceUnavailable)]
        public async Task<IActionResult> Health()
        {
            var result = await _aiService.GetHealthAsync();

            if (!result.Success)
                return StatusCode(StatusCodes.Status503ServiceUnavailable, result.ErrorMessage);

            return Ok(result.Data);
        }
    }
}
